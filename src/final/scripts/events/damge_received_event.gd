class_name DamageReceivedEvent
extends RefCounted

var amount: float = 0
var position: Vector2 = Vector2.ZERO
var target_is_player: bool = false

func emit() -> void:
	SignalBus.DamageReceived.emit(self)

func emit_with_args(amount: float, position: Vector2, target_is_player: bool) -> void:
	self.amount = amount
	self.position = position
	self.target_is_player = target_is_player
	emit()
