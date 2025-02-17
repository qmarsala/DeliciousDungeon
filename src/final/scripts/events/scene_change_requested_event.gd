class_name SceneChangeRequestedEvent
extends RefCounted

var scene_type: Enums.Scenes = Enums.Scenes.Main
var is_dungeon_floor_completion: bool = false

static func create(scene_type: Enums.Scenes, is_dungeon_floor_completion: bool = false) -> SceneChangeRequestedEvent:
	var instance = SceneChangeRequestedEvent.new()
	instance.scene_type = scene_type
	instance.is_dungeon_floor_completion = is_dungeon_floor_completion
	return instance

func emit() -> void:
	SignalBus.SceneChangeRequested.emit(self)
