class_name CharacterDiedEvent
extends RefCounted

var characted_id: Enums.Characters

func emit() -> void:
	SignalBus.CharacterDied.emit(self)

func emit_with_args(character_id: Enums.Characters) -> void:
	self.characted_id = characted_id
	emit()
