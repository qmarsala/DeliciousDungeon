extends Node2D
class_name Ignite

@onready var area_2d: Area2D = $Area2D

var data: AttackData

func init(attack_data: AttackData):
	data = attack_data

#todo: delay seems to be needed or we wont detect targets
# maybe this is fine - but is there something else we can do?
var delay = 0.05
var time = 0
func _process(delta: float) -> void:
	time += delta
	if time < delay: return

	var targets = area_2d.get_overlapping_areas()
	for t in targets:
		if t is Hitbox:
			var damage_amount = data.damage.front()
			t.receive_damage(damage_amount)
			if t.character.is_in_group(Interfaces.HasStatusEffects):
				for se in data.status_effects:
					t.character.apply_effect(se)
	queue_free()
