class_name StatusEffectSynergy

var status_effect: StatusEffect
var bonus_damage_modifier: float

func apply_synergy(attack: Attack) -> void:
	attack.damage *= bonus_damage_modifier
