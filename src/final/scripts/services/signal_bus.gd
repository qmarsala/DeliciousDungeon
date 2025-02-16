class_name SignalBusService
extends Node

signal SceneChange(scene: Enums.Scenes)
signal DamageReceived(event_details: DamageReceivedEvent)

# multi signals?
signal FireLit(position: Vector2)
signal EnemyDied(enemy_id: Enums.Enemies)
signal PlayerDied
# or
signal ActionPerformed(event_details: ActionPerformedEvent)
signal CharacterDied(character_id: Enums.Characters)
