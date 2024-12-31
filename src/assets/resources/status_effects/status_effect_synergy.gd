extends Resource
class_name StatusEffectSynergy

#todo: what else do we want these things to do?
@export var status_effect: StatusEffect
@export var bonus_damage_modifier: float

func apply(attack: Attack) -> void:
	attack.damage *= bonus_damage_modifier
