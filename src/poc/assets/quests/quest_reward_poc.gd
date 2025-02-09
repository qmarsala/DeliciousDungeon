class_name QuestReward
extends Resource

@export var description: String
# todo: track duration # -1 means till death?
@export var duration: float = -1 
# what do we want to give as rewards?
# food? wood? weapons?
# thought: could be a status???
@export var increased_max_health: int
@export var increased_max_nutrition: int
@export var increased_min_damage: int
@export var status_effect: StatusEffect
# we could apply statuses for rewards too?
# one idea could be a status that increases damage while abouve 50% nutrition?

# todo: a ui to show applied statuses?

func apply_reward(player: Player):
	if increased_max_health > 0:
		player.increase_max_health(increased_max_health, duration)
	if increased_min_damage > 0:
		player.increase_min_damage(increased_min_damage, duration)
	if status_effect:
		player.status_effects_component.apply_effect(status_effect)
