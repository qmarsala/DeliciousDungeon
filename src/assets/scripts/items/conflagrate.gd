extends Node2D
class_name Conflagrate

@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var damage: Array[float]

func init(damage_data: Array[float]):
	damage = damage_data

func deal_damage(amount):
	var targets = area_2d.get_overlapping_areas()
	for t in targets:
		if t is Hitbox:
			t.receive_damage(amount)

func _on_initial_damage_timer_timeout() -> void:
	if damage.size() > 0:
		deal_damage(damage[0])
	
func _on_mid_damage_timer_timeout() -> void:
	if damage.size() > 1:
		deal_damage(damage[1])
	elif damage.size() > 0:
		deal_damage(damage.back())
	
func _on_final_damage_timer_timeout() -> void:
	if damage.size() > 2:
		deal_damage([damage[2]])
	elif damage.size() > 0:
		deal_damage(damage.back())
	#animated_sprite_2d.visible = false
	queue_free()
