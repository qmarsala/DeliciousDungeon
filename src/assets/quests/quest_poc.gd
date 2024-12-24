class_name Quest
extends Resource

signal QuestCompleted(name: String)

@export var name: String
@export var description: String
@export var count: int

var completed: bool = false

var progress: int: 
	set(v):
		progress = v
		clamp(progress, 0, count)

func log_progress(more_progress: int) -> void:
	if completed: return
	progress += more_progress
	if progress >= count:
		completed = true
		QuestCompleted.emit(name)
