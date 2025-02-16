class_name SignalBusService
extends Node

signal SceneChange(scene: Enums.Scenes)
signal DamageReceived(event_details: DamageReceivedEvent)
signal ActionPerformed(event_details: ActionPerformedEvent)
signal CharacterDied(character_id: Enums.Characters)
