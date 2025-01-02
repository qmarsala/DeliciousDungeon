extends Node2D
class_name Ignite

@onready var area_2d: Area2D = $Area2D

var data: AbilityData

func init(ability_data: AbilityData, start: Vector2, target: Vector2) -> void:
	data = ability_data.duplicate()
	global_position = target

var delay = 0.1
var time = 0
func _process(delta: float) -> void:
	time += delta
	if time < delay: return

	var targets = area_2d.get_overlapping_areas()
	for t in targets:
		if t is Hitbox:
			var attack = Attack.new()
			attack.damage = data.damage
			attack.status_effects = data.status_effects
			t.apply_attack(attack)
	queue_free()
