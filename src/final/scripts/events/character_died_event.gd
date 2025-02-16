class_name CharacterDiedEvent
extends RefCounted

var characted_id: Enums.Characters

static func create(character_id: Enums.Characters) -> CharacterDiedEvent:
	var instance = CharacterDiedEvent.new()
	instance.character_id = character_id
	return instance

func emit() -> void:
	SignalBus.CharacterDied.emit(self)
