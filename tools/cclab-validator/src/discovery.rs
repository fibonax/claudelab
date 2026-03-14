use serde::Deserialize;
use std::path::{Path, PathBuf};

#[derive(Debug, Clone, Deserialize)]
#[serde(rename_all = "camelCase")]
#[allow(dead_code)]
pub struct ExerciseMetadata {
    pub id: String,
    pub title: String,
    pub track: String,
    pub difficulty: String,
    pub order: u32,
    pub prerequisites: Vec<String>,
    pub estimated_minutes: u32,
    pub concept: String,
}

#[derive(Debug, Clone)]
#[allow(dead_code)]
pub struct Exercise {
    pub metadata: ExerciseMetadata,
    pub dir: PathBuf,
}

impl Exercise {
    pub fn id(&self) -> &str {
        &self.metadata.id
    }

    pub fn title(&self) -> &str {
        &self.metadata.title
    }

    pub fn track(&self) -> &str {
        &self.metadata.track
    }
}

fn track_sort_key(track: &str) -> u32 {
    match track {
        "fundamentals" => 0,
        "skills" => 1,
        "workflows" => 2,
        "advanced" => 3,
        _ => 99,
    }
}

pub fn discover_exercises(plugin_root: &Path) -> anyhow::Result<Vec<Exercise>> {
    let exercises_dir = plugin_root.join("exercises");
    if !exercises_dir.exists() {
        anyhow::bail!("exercises directory not found at {}", exercises_dir.display());
    }

    // exercises/<track>/<exercise-id>/metadata.json
    let pattern = format!("{}/*/*/metadata.json", exercises_dir.display());

    let mut exercises = Vec::new();

    for entry in glob::glob(&pattern)? {
        let path = entry?;
        let content = std::fs::read_to_string(&path)?;
        let metadata: ExerciseMetadata = serde_json::from_str(&content)
            .map_err(|e| anyhow::anyhow!("Failed to parse {}: {}", path.display(), e))?;

        let dir = path.parent().unwrap().to_path_buf();
        exercises.push(Exercise { metadata, dir });
    }

    // Sort: by track priority, then by order within track
    exercises.sort_by(|a, b| {
        let track_cmp = track_sort_key(a.track()).cmp(&track_sort_key(b.track()));
        track_cmp.then(a.metadata.order.cmp(&b.metadata.order))
    });

    Ok(exercises)
}

pub fn filter_exercises(
    exercises: Vec<Exercise>,
    exercise_id: Option<&str>,
    track: Option<&str>,
) -> Vec<Exercise> {
    match (exercise_id, track) {
        (Some(id), _) => exercises.into_iter().filter(|e| e.id() == id).collect(),
        (_, Some(t)) => exercises.into_iter().filter(|e| e.track() == t).collect(),
        _ => exercises,
    }
}
