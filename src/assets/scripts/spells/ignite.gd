extends Node2D
class_name Ignite

@onready var area_2d: Area2D = $Area2D

var data: AbilityData

func init(attack_data: AbilityData):
	data = attack_data

#todo: delay seems to be needed or we wont detect targets
# maybe this is fine - but is there something else we can do?
var delay = 0.10
var time = 0
func _process(delta: float) -> void:
	time += delta
	if time < delay: return

	var targets = area_2d.get_overlapping_areas()
	for t in targets:
		if t is Hitbox:
			var damage_amount = data.damage.front()
			var attack = Attack.new()
			attack.damage = damage_amount
			attack.status_effects = data.status_effects
			t.apply_attack(attack)
	queue_free()
