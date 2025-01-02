extends AbilityScene
class_name SwordAttack

# feels like once we have all our different types of attacks in place
# nodes like swordswing may not be needed?
# the hurtbox it he main thing we need - and a way to init it from ability data
# what other benefit is there to creating a script for each attack scene?
# vs one configurable one that reads ability data

@onready var hurtbox: Hurtbox = $MeleeHurtbox

var target_positon = Vector2(0,0)
var starting_postition = Vector2(0,0)

func init(ability_data: AbilityData, start: Vector2, target: Vector2) -> void:
	data = ability_data.duplicate()
	starting_postition = start
	target_positon = target
	global_position = start

func _ready() -> void:
	look_at(target_positon)
	var attack = Attack.new()
	attack.damage = data.damage
	attack.status_effects = data.status_effects
	attack.effect_synergy = data.status_effect_synergy
	hurtbox.init(attack)
