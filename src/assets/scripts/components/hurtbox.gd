class_name Hurtbox
extends Area2D

var attack: Attack
var free_on_collision: bool

func init(attack_data: Attack, apply_on_entered: bool, free_on_collision: bool = false):
	attack = attack_data
	if apply_on_entered:
		area_entered.connect(on_area_entererd)

func apply_attack():
	var targets = get_overlapping_areas()
	for t in targets:
		on_area_entererd(t)

func on_area_entererd(area: Area2D) -> void:
	if area is Hitbox:
		area.apply_attack(attack)
		if free_on_collision:
			queue_free()
