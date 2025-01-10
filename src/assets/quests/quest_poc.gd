class_name Quest
extends Resource

#todo: create 'quest steps' and allow quests to have several steps
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
		SignalBusService.QuestCompleted.emit(self)

func reset() -> void:
	completed = false
	progress = 0
