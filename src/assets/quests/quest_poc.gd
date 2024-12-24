class_name Quest
extends Resource

signal QuestCompleted(name: String)

@export var name: String
@export var description: String
@export var count: int

var progress: int: 
	set(v):
		progress = v
		clamp(progress, 0, count)

func log_progress(more_progress: int) -> bool:
	if is_complete(): return true

	progress += more_progress
	var completed = is_complete()
	if completed:
		QuestCompleted.emit(name)
	return completed

func is_complete() -> bool:
	return progress >= count
