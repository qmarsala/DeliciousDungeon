class_name Attack

var damage: float
var status_effects: Array[StatusEffect] = []
var effect_synergy: StatusEffectSynergy

func apply(health_component: HealthComponent, 
	status_effects_component: StatusEffectComponent,
	armour_value: float = 0,
	evasion_value: float = 0) -> void:
	if status_effects_component:
		if effect_synergy and status_effects_component.has_effect(effect_synergy.status_effect):
			effect_synergy.apply(self)
		for effect in status_effects:
			status_effects_component.apply_effect(effect)
	if health_component and damage > 0:
		#moved armour poc: hit box is where we apply an attack, does it make sense for it to happen here then?
		if randf() <= evasion_value:
			health_component.receive_damage(-1)
		else:
			health_component.receive_damage(damage - armour_value)
