class_name StatusEffectComponent
extends Node

var status_effects: Array[StatusEffect]
var node: Node

func init(n: Node):
	node = n
	node.add_to_group(Interfaces.HasStatusEffects)

var time: float = 0
func _process(delta: float) -> void:
	time += delta
	var expired_effects = status_effects.filter(func(se: StatusEffect): return se.is_expired(time))
	for ee in expired_effects: 
		status_effects.erase(ee)
	for se in status_effects:
		if se.is_applicable(time):
			se.tick(time)
			node.receive_damage(se.damage)

# pulling these into a component isnt helping - since a parent script
# may still need to accept calls for these methods?
func has_effect(effect):
	if effect is StatusEffect:
		return status_effects.filter(func(e): return e.effect_name == effect.effect_name).size() > 0
	else:
		return status_effects.filter(func(e): return e.effect_name == effect).size() > 0

func apply_effect(effect: StatusEffect):
	if status_effects.has(effect):
		var se_idx = status_effects.find(effect)
		status_effects[se_idx].apply(time)
	else:
		var new_effect = effect.duplicate()
		status_effects.append(new_effect)
		new_effect.apply(time)
