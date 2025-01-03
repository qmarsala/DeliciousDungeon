extends AbilityScene
class_name SwordAttack

@onready var aim: RayCast2D = $Aim
@onready var melee_hurtbox: Hurtbox = $Aim/MeleeHurtbox
func _ready() -> void:
	aim.global_position = starting_position
	aim.look_at(target_position)
	var attack = Attack.new()
	attack.damage = data.damage
	attack.status_effects = data.status_effects
	attack.effect_synergy = data.status_effect_synergy
	melee_hurtbox.init(attack)

var time = 0
func _process(delta: float) -> void:
	time += delta
	if time > .05:
		melee_hurtbox.apply_attack()
		queue_free()
