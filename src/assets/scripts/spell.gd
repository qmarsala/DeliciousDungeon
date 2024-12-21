extends Node2D
class_name Spell

@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_initial_damage_timer_timeout() -> void:
	deal_damage(1)

func _on_final_damage_timer_timeout() -> void:
	animated_sprite_2d.visible = false
	deal_damage(3)
	queue_free()

func deal_damage(amount):
	var targets = area_2d.get_overlapping_areas()
	for t in targets:
		if t is Hitbox:
			t.receive_damage(amount)

func _on_mid_damage_timer_timeout() -> void:
	deal_damage(2)
