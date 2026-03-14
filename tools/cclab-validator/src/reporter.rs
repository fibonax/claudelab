use colored::Colorize;

use crate::runner::ExerciseResult;

pub fn print_header() {
    println!();
    println!("{}", "cclab-validator: Exercise Solvability Tester".bold());
    println!("{}", "=".repeat(60));
    println!();
}

pub fn print_result(result: &ExerciseResult) {
    let status = if result.passed {
        "PASS".green().bold()
    } else {
        "FAIL".red().bold()
    };

    let duration = format!("{:.1}s", result.duration_secs);
    let cost = result
        .cost_usd
        .map(|c| format!(", ${:.4}", c))
        .unwrap_or_default();

    println!(
        "  {:<8} {:<30} {}  ({}{})",
        result.exercise_id,
        result.title,
        status,
        duration.dimmed(),
        cost.dimmed(),
    );

    if let Some(ref err) = result.error {
        println!("           {}", format!("-> {}", err).red());
    }
}

pub fn print_summary(results: &[ExerciseResult]) {
    let total = results.len();
    let passed = results.iter().filter(|r| r.passed).count();
    let failed = total - passed;

    println!();
    println!("{}", "-".repeat(60));

    if failed == 0 {
        println!(
            "{}",
            format!("  All {}/{} exercises passed!", passed, total)
                .green()
                .bold()
        );
    } else {
        println!(
            "  Results: {} passed, {} failed  ({} total)",
            format!("{}", passed).green(),
            format!("{}", failed).red(),
            total
        );

        println!();
        println!("  {} exercises:", "Failed".red().bold());
        for result in results.iter().filter(|r| !r.passed) {
            println!("    - {} ({})", result.exercise_id, result.title);
        }
    }

    println!();
}

