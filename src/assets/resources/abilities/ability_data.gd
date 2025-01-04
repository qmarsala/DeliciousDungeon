class_name AbilityData
extends Resource

@export var target_self: bool
@export var animation_name: String = "attack"
@export var ability_sound: AudioStream
@export var cast_time = .3
@export var cooldown = 1.3
@export var damage: float = 0
@export var heal: float = 0
@export var status_effects: Array[StatusEffect] = []
@export var status_effect_synergy: StatusEffectSynergy

func apply_weapon_bonus(weapon: WeaponData) -> AbilityData:
	var ability_data: AbilityData = self.duplicate()
	ability_data.cooldown -= cooldown * weapon.cooldown_reduction
	return ability_data
