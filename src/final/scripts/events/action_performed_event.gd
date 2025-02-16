class_name ActionPerformedEvent
extends RefCounted

var action_id: Enums.Actions = Enums.Actions.None
var position: Vector2 = Vector2.ZERO

func emit() -> void:
	SignalBus.ActionPerformed.emit(self)

func emit_with_args(action_id: Enums.Actions, position: Vector2) -> void:
	self.action_id = action_id
	self.position = position
	emit()
