use std::io::{BufRead, BufReader, Write};
use std::path::Path;
use std::process::{Command, Stdio};
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;
use std::time::Instant;

use colored::Colorize;
use serde_json::Value;

use crate::discovery::Exercise;

#[derive(Debug)]
#[allow(dead_code)]
pub struct ExerciseResult {
    pub exercise_id: String,
    pub title: String,
    pub passed: bool,
    pub duration_secs: f64,
    pub cost_usd: Option<f64>,
    pub output: String,
    pub error: Option<String>,
}

fn reset_exercise(exercise: &Exercise) -> anyhow::Result<()> {
    let home = std::env::var("HOME")?;
    let workspace = format!("{}/.cclab/workspace/{}", home, exercise.id());

    // Clean workspace for fresh start
    if Path::new(&workspace).exists() {
        std::fs::remove_dir_all(&workspace)?;
    }

    // Reset progress.json to target this exercise
    let cclab_dir = format!("{}/.cclab", home);
    std::fs::create_dir_all(&cclab_dir)?;

    let progress = serde_json::json!({
        "current_exercise": exercise.id(),
        "completed": [],
        "hints_seen": {},
        "started_at": chrono_now(),
        "updated_at": chrono_now()
    });

    std::fs::write(
        format!("{}/progress.json", cclab_dir),
        serde_json::to_string_pretty(&progress)?,
    )?;

    Ok(())
}

fn chrono_now() -> String {
    let output = Command::new("date")
        .args(["-u", "+%Y-%m-%dT%H:%M:%S.000Z"])
        .output();

    match output {
        Ok(o) => String::from_utf8_lossy(&o.stdout).trim().to_string(),
        Err(_) => "2026-01-01T00:00:00.000Z".to_string(),
    }
}

/// Format a stream-json event for display. Returns (display_text, raw_text_for_detection).
fn format_stream_event(line: &str) -> (Option<String>, Option<String>) {
    let v: Value = match serde_json::from_str(line) {
        Ok(v) => v,
        Err(_) => return (None, None),
    };

    let event_type = match v.get("type").and_then(|t| t.as_str()) {
        Some(t) => t,
        None => return (None, None),
    };

    match event_type {
        "assistant" => {
            let content = match v
                .get("message")
                .and_then(|m| m.get("content"))
                .and_then(|c| c.as_array())
            {
                Some(c) => c,
                None => return (None, None),
            };

            let mut display = Vec::new();
            let mut raw = Vec::new();

            for block in content {
                let block_type = block.get("type").and_then(|t| t.as_str()).unwrap_or("");
                match block_type {
                    "text" => {
                        if let Some(text) = block.get("text").and_then(|t| t.as_str()) {
                            display.push(format!(
                                "  {} {}",
                                "[claude]".dimmed(),
                                text
                            ));
                            raw.push(text.to_string());
                        }
                    }
                    "tool_use" => {
                        let name = block
                            .get("name")
                            .and_then(|n| n.as_str())
                            .unwrap_or("unknown");
                        let input = block.get("input").cloned().unwrap_or(Value::Null);

                        // Show tool call with relevant details
                        let detail = match name {
                            "Skill" => {
                                let skill = input
                                    .get("skill")
                                    .and_then(|s| s.as_str())
                                    .unwrap_or("?");
                                format!("/{}",skill)
                            }
                            "Write" | "Edit" | "Read" => {
                                let path = input
                                    .get("file_path")
                                    .and_then(|p| p.as_str())
                                    .unwrap_or("?");
                                // Show just filename
                                let short = Path::new(path)
                                    .file_name()
                                    .map(|f| f.to_string_lossy().to_string())
                                    .unwrap_or_else(|| path.to_string());
                                format!("{} {}", name, short)
                            }
                            "Bash" => {
                                let cmd = input
                                    .get("command")
                                    .and_then(|c| c.as_str())
                                    .unwrap_or("?");
                                let truncated: String = cmd.chars().take(60).collect();
                                format!("Bash({})", truncated)
                            }
                            _ => name.to_string(),
                        };

                        display.push(format!(
                            "  {} {}",
                            "[tool]".cyan(),
                            detail
                        ));
                    }
                    _ => {}
                }
            }

            let display_str = if display.is_empty() {
                None
            } else {
                Some(display.join("\n"))
            };
            let raw_str = if raw.is_empty() {
                None
            } else {
                Some(raw.join("\n"))
            };

            (display_str, raw_str)
        }

        "user" => {
            // Tool results come back as user messages
            let content = match v
                .get("message")
                .and_then(|m| m.get("content"))
                .and_then(|c| c.as_array())
            {
                Some(c) => c,
                None => return (None, None),
            };

            let mut display = Vec::new();
            let mut raw = Vec::new();

            for block in content {
                let block_type = block.get("type").and_then(|t| t.as_str()).unwrap_or("");
                if block_type == "tool_result" {
                    if let Some(text) = block.get("content").and_then(|c| c.as_str()) {
                        // Show tool result, truncate long output
                        let lines: Vec<&str> = text.lines().collect();
                        let preview_lines = if lines.len() > 20 {
                            let mut preview: Vec<&str> = lines[..10].to_vec();
                            preview.push("  ... (truncated)");
                            preview.extend_from_slice(&lines[lines.len() - 10..]);
                            preview
                        } else {
                            lines
                        };

                        for line in &preview_lines {
                            display.push(format!(
                                "  {} {}",
                                "[result]".yellow(),
                                line
                            ));
                        }
                        raw.push(text.to_string());
                    }
                }
            }

            let display_str = if display.is_empty() {
                None
            } else {
                Some(display.join("\n"))
            };
            let raw_str = if raw.is_empty() {
                None
            } else {
                Some(raw.join("\n"))
            };

            (display_str, raw_str)
        }

        "result" => {
            let cost = v
                .get("total_cost_usd")
                .and_then(|c| c.as_f64())
                .map(|c| format!("${:.4}", c))
                .unwrap_or_default();
            let result_text = v
                .get("result")
                .and_then(|r| r.as_str())
                .unwrap_or("");

            let display = format!(
                "  {} cost: {}",
                "[done]".green(),
                cost
            );

            (Some(display), Some(result_text.to_string()))
        }

        _ => (None, None),
    }
}

pub fn run_exercise(
    exercise: &Exercise,
    plugin_root: &Path,
    model: &str,
    max_budget: f64,
    verbose: bool,
) -> ExerciseResult {
    let start = Instant::now();
    let exercise_id = exercise.id().to_string();
    let title = exercise.title().to_string();

    // Step 1: Reset workspace and progress
    if let Err(e) = reset_exercise(exercise) {
        return ExerciseResult {
            exercise_id,
            title,
            passed: false,
            duration_secs: start.elapsed().as_secs_f64(),
            cost_usd: None,
            output: String::new(),
            error: Some(format!("Reset failed: {}", e)),
        };
    }

    // Step 2: Spawn claude -p to solve the exercise
    let prompt = r#"You are testing a cclab exercise by solving it as a real learner would.

Follow these steps exactly:
1. Run /cclab:start to begin the exercise — this will set up the workspace and show instructions.
2. Read the instructions carefully.
3. Solve the exercise by creating/editing the required files in the workspace.
4. Run /cclab:check to validate your solution.

Important:
- Do exactly what the instructions ask, nothing more.
- Work only in the workspace directory shown by /cclab:start.
- You MUST run /cclab:check at the end to validate."#;

    let plugin_dir = plugin_root.to_string_lossy().to_string();
    let budget_str = format!("{:.2}", max_budget);

    let mut args = vec![
        "-p",
        prompt,
        "--plugin-dir",
        &plugin_dir,
        "--model",
        model,
        "--max-budget-usd",
        &budget_str,
        "--no-session-persistence",
        "--permission-mode",
        "bypassPermissions",
    ];

    // In verbose mode, use stream-json to get full event stream
    if verbose {
        args.extend_from_slice(&["--output-format", "stream-json", "--verbose"]);
    }

    let mut cmd = Command::new("claude");
    cmd.args(&args);
    cmd.stdout(Stdio::piped());
    cmd.stderr(Stdio::piped());

    let child = cmd.spawn();

    match child {
        Ok(mut child) => {
            let child_stdout = child.stdout.take();
            let child_stderr = child.stderr.take();

            if verbose {
                // Verbose: parse stream-json events and display in real-time
                eprintln!(
                    "\n  {} {} ({})",
                    ">>>".bold(),
                    exercise_id.bold(),
                    title
                );
                eprintln!("  {}", "-".repeat(50));

                let stdout_handle = std::thread::spawn(move || {
                    let mut all_raw = Vec::new();
                    let mut cost: Option<f64> = None;

                    if let Some(stdout) = child_stdout {
                        let reader = BufReader::new(stdout);
                        for line in reader.lines() {
                            if let Ok(line) = line {
                                // Try to extract cost from result event
                                if let Ok(v) = serde_json::from_str::<Value>(&line) {
                                    if v.get("type").and_then(|t| t.as_str()) == Some("result") {
                                        cost = v.get("total_cost_usd").and_then(|c| c.as_f64());
                                    }
                                }

                                let (display, raw) = format_stream_event(&line);
                                if let Some(d) = display {
                                    println!("{}", d);
                                }
                                if let Some(r) = raw {
                                    all_raw.push(r);
                                }
                            }
                        }
                    }
                    (all_raw.join("\n"), cost)
                });

                // Drain stderr silently
                let stderr_handle = std::thread::spawn(move || {
                    if let Some(stderr) = child_stderr {
                        let reader = BufReader::new(stderr);
                        for _ in reader.lines() {}
                    }
                });

                let status = child.wait();
                let (raw_output, cost) = stdout_handle.join().unwrap_or_default();
                let _ = stderr_handle.join();
                let duration_secs = start.elapsed().as_secs_f64();

                eprintln!("  {}", "-".repeat(50));

                let passed = detect_pass(&raw_output);
                let error = match status {
                    Ok(s) if !s.success() && !passed => {
                        Some(format!("claude exited with code: {}", s))
                    }
                    Err(e) => Some(format!("Failed to wait for claude: {}", e)),
                    _ => None,
                };

                ExerciseResult {
                    exercise_id,
                    title,
                    passed,
                    duration_secs,
                    cost_usd: cost,
                    output: raw_output,
                    error,
                }
            } else {
                // Non-verbose: show spinner while waiting
                let done = Arc::new(AtomicBool::new(false));
                let done_clone = done.clone();
                let spinner_exercise_id = exercise_id.clone();
                let spinner_title = title.clone();
                let spinner_start = start.clone();

                let spinner = std::thread::spawn(move || {
                    let frames = [
                        "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏",
                    ];
                    let mut i = 0;
                    while !done_clone.load(Ordering::Relaxed) {
                        let elapsed = spinner_start.elapsed().as_secs();
                        eprint!(
                            "\r  {} {:<8} {:<30} solving... {}s",
                            frames[i % frames.len()],
                            spinner_exercise_id,
                            spinner_title,
                            elapsed,
                        );
                        let _ = std::io::stderr().flush();
                        std::thread::sleep(std::time::Duration::from_millis(100));
                        i += 1;
                    }
                    eprint!("\r{}\r", " ".repeat(80));
                    let _ = std::io::stderr().flush();
                });

                // Collect output in background threads
                let stdout_handle = std::thread::spawn(move || {
                    let mut buf = String::new();
                    if let Some(stdout) = child_stdout {
                        let reader = BufReader::new(stdout);
                        for line in reader.lines() {
                            if let Ok(line) = line {
                                buf.push_str(&line);
                                buf.push('\n');
                            }
                        }
                    }
                    buf
                });

                let stderr_handle = std::thread::spawn(move || {
                    if let Some(stderr) = child_stderr {
                        let reader = BufReader::new(stderr);
                        for _ in reader.lines() {}
                    }
                });

                let status = child.wait();
                done.store(true, Ordering::Relaxed);
                let _ = spinner.join();

                let stdout_str = stdout_handle.join().unwrap_or_default();
                let _ = stderr_handle.join();
                let duration_secs = start.elapsed().as_secs_f64();

                let passed = detect_pass(&stdout_str);
                let error = match status {
                    Ok(s) if !s.success() && !passed => {
                        Some(format!("claude exited with code: {}", s))
                    }
                    Err(e) => Some(format!("Failed to wait for claude: {}", e)),
                    _ => None,
                };

                ExerciseResult {
                    exercise_id,
                    title,
                    passed,
                    duration_secs,
                    cost_usd: None,
                    output: stdout_str,
                    error,
                }
            }
        }
        Err(e) => ExerciseResult {
            exercise_id,
            title,
            passed: false,
            duration_secs: start.elapsed().as_secs_f64(),
            cost_usd: None,
            output: String::new(),
            error: Some(format!("Failed to spawn claude: {}", e)),
        },
    }
}

fn detect_pass(output: &str) -> bool {
    let has_pass = output.contains("PASS —") || output.contains("PASS —");
    let has_fail = output.contains("NOT YET —") || output.contains("NOT YET —");

    if has_pass && !has_fail {
        return true;
    }

    if output.contains("All checks passed") {
        return true;
    }

    false
}
