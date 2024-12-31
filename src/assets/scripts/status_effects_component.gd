class_name StatusEffectComponent
extends Node

signal Proc(effect: StatusEffect)

var status_effects: Array[StatusEffect]

var time: float = 0
func _process(delta: float) -> void:
	time += delta
	var expired_effects = status_effects.filter(func(se: StatusEffect): return se.is_expired(time))
	for ee in expired_effects: 
		status_effects.erase(ee)
	for se in status_effects:
		if se.is_applicable(time):
			se.tick(time)
			Proc.emit(se)

# pulling these into a component isnt helping - since a parent script
# may still need to accept calls for these methods?
func has_effect(effect) -> bool:
	return find_effects(effect).size() > 0

func find_effects(effect) -> Array[StatusEffect]:
	if effect is StatusEffect:
		return status_effects.filter(func(e): return e.effect_name == effect.effect_name)
	else:
		return status_effects.filter(func(e): return e.effect_name == effect)

func apply_effect(effect: StatusEffect):
	var existing_effects = find_effects(effect)
	if existing_effects.size() > 0:
		existing_effects.front().extend(time)
	else:
		var new_effect = effect.duplicate()
		status_effects.append(new_effect)
		new_effect.tick(time)
	print(status_effects)
