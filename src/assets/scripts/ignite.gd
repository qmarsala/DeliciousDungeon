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
			t.receive_damage(damage_amount)
			if t.node.is_in_group(Interfaces.HasStatusEffects):
				for se in data.status_effects:
					# how else could we benefit from it being a component?
					# even with this we have to assume a parent exists with this property
					# which required several changes to 'add' the component
					t.node.status_effects_component.apply_effect(se)
	queue_free()
