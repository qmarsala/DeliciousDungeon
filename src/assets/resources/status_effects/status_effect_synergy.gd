extends Resource
class_name StatusEffectSynergy

#todo: what else do we want these things to do?
@export var status_effect: StatusEffect
@export var bonus_damage_modifier: float
@export var adds_new_effect: bool
@export var added_status_effect: StatusEffect

func apply(attack: Attack) -> void:
	# should this be += dmg * mod or just *= mod?
	attack.damage += attack.damage * bonus_damage_modifier
	if adds_new_effect:
		attack.status_effects.append(added_status_effect)
