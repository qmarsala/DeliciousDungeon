class_name StatusEffectComponent
extends Node

var status_effects: Array[StatusEffect]

var health_component: HealthComponent
var state_machine: StateMachine

func init(health: HealthComponent, state: StateMachine) -> void:
	health_component = health
	state_machine = state 

var time: float = 0
func _process(delta: float) -> void:
	time += delta
	var expired_effects = status_effects.filter(func(se: StatusEffect): return se.is_expired(time))
	for ee in expired_effects: 
		ee.on_expired(self)
		status_effects.erase(ee)
	for se in status_effects:
		if se.is_applicable(time):
			se.apply(time, health_component, state_machine)

func has_effect(effect) -> bool:
	return find_effects(effect).size() > 0

func find_effects(effect) -> Array[StatusEffect]:
	if effect is StatusEffect:
		return status_effects.filter(func(e): return e.effect_name == effect.effect_name)
	else:
		return status_effects.filter(func(e): return e.effect_name == effect)

func apply_effect(effect: StatusEffect) -> void:
	if has_effect(effect.blocked_by_effect): return
	var existing_effects = find_effects(effect)
	if existing_effects.size() > 0:
		existing_effects.front().extend(time)
	else:
		var new_effect = effect.duplicate()
		status_effects.append(new_effect)
		new_effect.apply(time, health_component, state_machine)
