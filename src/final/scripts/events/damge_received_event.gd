class_name DamageReceivedEvent
extends RefCounted

var amount: float = 0
var position: Vector2 = Vector2.ZERO
var target_is_player: bool = false

static func create(amount: float, position: Vector2, target_is_player: bool) -> DamageReceivedEvent:
	var instance = DamageReceivedEvent.new()
	instance.amount = amount
	instance.position = position
	instance.target_is_player = target_is_player
	return instance

func emit() -> void:
	SignalBus.DamageReceived.emit(self)
