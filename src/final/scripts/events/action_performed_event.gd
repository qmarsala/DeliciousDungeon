class_name ActionPerformedEvent
extends RefCounted

var action_id: Enums.Actions = Enums.Actions.None
var position: Vector2 = Vector2.ZERO

static func create(action_id: Enums.Actions, position: Vector2) -> ActionPerformedEvent:
	var instance = ActionPerformedEvent.new()
	instance.action_id = action_id
	instance.position = position
	return instance

func emit() -> void:
	SignalBus.ActionPerformed.emit(self)
