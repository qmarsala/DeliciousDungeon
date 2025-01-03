extends AbilityScene
class_name Conflagrate

@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func initialized() -> void:
	global_position = target_position

func deal_damage(amount):
	var targets = area_2d.get_overlapping_areas()
	for t in targets:
		if t is Hitbox:
			var attack = Attack.new()
			attack.damage = amount
			attack.effect_synergy = data.status_effect_synergy
			t.apply_attack(attack)

func _on_initial_damage_timer_timeout() -> void:
		deal_damage(data.damage)
	
func _on_mid_damage_timer_timeout() -> void:
		deal_damage(data.damage + 1)
	
func _on_final_damage_timer_timeout() -> void:
	deal_damage(data.damage + 2)
	queue_free()
