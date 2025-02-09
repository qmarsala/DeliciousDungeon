extends Node2D
class_name Trap

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var area_2d: Area2D = $Area2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	animated_sprite_2d.play("trigger")
	timer.start(.5)

func _on_area_2d_area_entered(area: Area2D) -> void:
	animated_sprite_2d.play("trigger")
	timer.start(.5)

func _on_timer_timeout() -> void:
	animated_sprite_2d.play("default")
	var targets = area_2d.get_overlapping_areas()
	for t in targets:
		if t is Hitbox:
			var attack = Attack.new()
			attack.damage = 2
			t.apply_attack(attack)
