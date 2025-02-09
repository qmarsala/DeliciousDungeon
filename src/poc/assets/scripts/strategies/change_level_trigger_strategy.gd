class_name ChangeLevelStrategy
extends TriggerStrategy

@export var scene: Enums.Scenes = Enums.Scenes.Dungeon

func execute(body: Node2D) -> void:
	if body.is_in_group("Player"):
		SignalBusService.SceneChange.emit(scene)
