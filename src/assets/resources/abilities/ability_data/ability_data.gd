class_name AbilityData
extends Resource

@export var targets_player: bool
@export var targets_enemy: bool
@export var animation_name: String = "attack"
@export var ability_sound: AudioStream
@export var cast_time = .3
@export var cooldown = 1.3
@export var show_castbar: bool = true
@export var damage: float = 0
@export var heal: float = 0
@export var ability_range = 20
@export var bonus_range = 0
@export var status_effects: Array[StatusEffect] = []
@export var status_effect_synergy: StatusEffectSynergy

# projectile data: do they make sense here?
@export var speed = 300.0
@export var can_pierce = false
@export var max_pierce_count = 1

var max_range: float:
	get: return ability_range + bonus_range

func apply_weapon_stats(weapon: WeaponData) -> AbilityData:
	var ability_data: AbilityData = self.duplicate()
	ability_data.cooldown -= cooldown * weapon.cooldown_reduction
	ability_data.ability_range = weapon.max_range
	return ability_data
