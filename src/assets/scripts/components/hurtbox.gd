class_name Hurtbox
extends Area2D

var attack: Attack
var free_on_collision: bool

func init(attack_data: Attack, 
	attacks_enemy: bool = true,
	attacks_player: bool = false,
	apply_on_entered: bool = false, 
	free_on_collision: bool = false):
	attack = attack_data
	if apply_on_entered:
		area_entered.connect(on_area_entererd)
	set_collision_mask_value(6, attacks_player)
	set_collision_mask_value(7, attacks_enemy)

func apply_attack():
	var targets = get_overlapping_areas()
	for t in targets:
		on_area_entererd(t)

func on_area_entererd(area: Area2D) -> void:
	if area is Hitbox:
		area.apply_attack(attack)
		if free_on_collision:
			queue_free()
