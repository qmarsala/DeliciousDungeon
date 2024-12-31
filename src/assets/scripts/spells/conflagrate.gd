extends Node2D
class_name Conflagrate

@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var data: AbilityData

func init(attack_data: AbilityData):
	data = attack_data

func deal_damage(amount):
	var targets = area_2d.get_overlapping_areas()
	for t in targets:
		if t is Hitbox:
			var attack = Attack.new()
			attack.damage = amount
			attack.effect_synergy = data.status_effect_synergy
			t.apply_attack(attack)

func _on_initial_damage_timer_timeout() -> void:
	if data.damage.size() > 0:
		deal_damage(data.damage[0])
	
func _on_mid_damage_timer_timeout() -> void:
	if data.damage.size() > 1:
		deal_damage(data.damage[1])
	elif data.damage.size() > 0:
		deal_damage(data.damage.back())
	
func _on_final_damage_timer_timeout() -> void:
	if data.damage.size() > 2:
		deal_damage(data.damage[2])
	elif data.damage.size() > 0:
		deal_damage(data.damage.back())
	queue_free()
