class_name SignalBusServicePoc
extends Node

#todo: what data do we need if any to pass here?
signal SceneChange(scene: Enums.Scenes)

#probably want to know who got damaged by what?
signal DamageReceived(damage: float, position: Vector2, is_player_target: bool)


# quest poc: is this how we want to track actions we care about?
signal EnemyDied(enemy_id: int)
signal ActionPerformed(action_id: int)
signal QuestCompleted(quest: Quest)

#how do we want to communicate to the ui componens? signal bus?
signal Casting(time_left: float, total_time: float)
# maybe these could be the same and we send an action or color?
signal Resting(time_left: float, total_time: float)
