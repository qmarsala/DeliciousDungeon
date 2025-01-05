class_name Attack

var damage: float
var status_effects: Array[StatusEffect] = []
var effect_synergy: StatusEffectSynergy

func apply(health_component: HealthComponent, status_effects_component: StatusEffectComponent) -> void:
	if status_effects_component:
		if effect_synergy and status_effects_component.has_effect(effect_synergy.status_effect):
			effect_synergy.apply(self)
		for effect in status_effects:
			status_effects_component.apply_effect(effect)
	if health_component and damage > 0:
		health_component.receive_damage(damage)
