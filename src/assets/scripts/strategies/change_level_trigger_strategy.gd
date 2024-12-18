class_name ChangeLevelStrategy
extends TriggerStrategy

func execute(body: Node2D) -> void:
	if body.is_in_group("Player"):
		SignalBusService.SceneChange.emit()
