mod discovery;
mod reporter;
mod runner;

use std::path::PathBuf;
use std::process;

use clap::Parser;

/// cclab-validator: Exercise solvability tester.
///
/// Spawns Claude Code to solve each exercise as a real learner would
/// (using /cclab:start and /cclab:check), then reports pass/fail.
/// If an exercise fails, its instructions or validation are broken.
#[derive(Parser)]
#[command(name = "cclab-validator", version, about)]
struct Cli {
    /// Run a specific exercise by ID (e.g., cc-001, wf-003)
    #[arg(short, long)]
    exercise: Option<String>,

    /// Run all exercises in a track (e.g., fundamentals, workflows)
    #[arg(short, long)]
    track: Option<String>,

    /// Run all exercises
    #[arg(short, long, default_value_t = false)]
    all: bool,

    /// Model to use (default: sonnet)
    #[arg(short, long, default_value = "sonnet")]
    model: String,

    /// Maximum budget in USD per exercise (default: 0.50)
    #[arg(long, default_value_t = 0.50)]
    max_budget: f64,

    /// Show Claude's full output for each exercise
    #[arg(short, long, default_value_t = false)]
    verbose: bool,

    /// Continue running after a failure instead of stopping
    #[arg(short, long, default_value_t = false)]
    continue_on_fail: bool,

    /// Path to cclab plugin root (auto-detected if not set)
    #[arg(long)]
    plugin_dir: Option<PathBuf>,
}

fn resolve_plugin_root(cli_path: Option<PathBuf>) -> anyhow::Result<PathBuf> {
    if let Some(path) = cli_path {
        return Ok(path);
    }

    // Auto-detect: walk up from current executable or cwd
    let cwd = std::env::current_dir()?;

    // Check if we're inside the cclab repo (look for .claude-plugin/plugin.json)
    let mut dir = cwd.as_path();
    loop {
        if dir.join(".claude-plugin/plugin.json").exists() {
            return Ok(dir.to_path_buf());
        }
        match dir.parent() {
            Some(parent) => dir = parent,
            None => break,
        }
    }

    anyhow::bail!(
        "Could not find cclab plugin root. Run from inside the cclab repo or use --plugin-dir"
    )
}

fn main() {
    let cli = Cli::parse();

    // Must specify at least one target
    if cli.exercise.is_none() && cli.track.is_none() && !cli.all {
        eprintln!("Error: specify --exercise <id>, --track <name>, or --all");
        eprintln!("Run with --help for usage.");
        process::exit(1);
    }

    let plugin_root = match resolve_plugin_root(cli.plugin_dir) {
        Ok(p) => p,
        Err(e) => {
            eprintln!("Error: {}", e);
            process::exit(1);
        }
    };

    // Discover exercises
    let exercises = match discovery::discover_exercises(&plugin_root) {
        Ok(e) => e,
        Err(e) => {
            eprintln!("Error discovering exercises: {}", e);
            process::exit(1);
        }
    };

    if exercises.is_empty() {
        eprintln!("No exercises found in {}", plugin_root.display());
        process::exit(1);
    }

    // Filter
    let targets = discovery::filter_exercises(
        exercises,
        cli.exercise.as_deref(),
        cli.track.as_deref(),
    );

    if targets.is_empty() {
        eprintln!(
            "No exercises matched (exercise: {:?}, track: {:?})",
            cli.exercise, cli.track
        );
        process::exit(1);
    }

    reporter::print_header();
    println!("  Testing {} exercise(s) with model: {}\n", targets.len(), cli.model);

    let mut results = Vec::new();
    let mut has_failure = false;

    for exercise in &targets {
        let result = runner::run_exercise(
            exercise,
            &plugin_root,
            &cli.model,
            cli.max_budget,
            cli.verbose,
        );

        reporter::print_result(&result);

        if !result.passed {
            has_failure = true;
        }

        results.push(result);

        if has_failure && !cli.continue_on_fail {
            println!();
            println!("  Stopping on first failure. Use --continue-on-fail to run all.");
            break;
        }
    }

    reporter::print_summary(&results);

    if has_failure {
        process::exit(1);
    }
}
