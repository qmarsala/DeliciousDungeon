class_name Hurtbox
extends Area2D

var attack: Attack

func init(attack_data: Attack, 
	targets_player: bool = false,
	targets_enemy: bool = true,
	apply_on_entered: bool = false):
	attack = attack_data
	if apply_on_entered:
		area_entered.connect(on_area_entererd)
	set_collision_mask_value(6, targets_player)
	set_collision_mask_value(7, targets_enemy)

func apply_attack():
	var targets = get_overlapping_areas()
	for t in targets:
		apply_attack_to_hitbox(t)

func on_area_entererd(area: Area2D) -> void:
	apply_attack_to_hitbox(area)

func apply_attack_to_hitbox(area: Area2D):
	if area is Hitbox:
		area.apply_attack(attack)
