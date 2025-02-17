class_name SceneChangeEvent
extends RefCounted

var scene_type: Enums.Scenes = Enums.Scenes.Main
var level: int = 0

static func create(scene_type: Enums.Scenes, level: int = 0) -> SceneChangeEvent:
	var instance = SceneChangeEvent.new()
	instance.scene_type = scene_type
	instance.level = level
	return instance

func emit() -> void:
	SignalBus.SceneChange.emit(self)
