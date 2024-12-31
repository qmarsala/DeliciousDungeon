class_name WeaponData
extends ItemData

@export var max_range: float
@export var cooldown_reduction: float = 0 # represents a perecentage subracted from cooldown
#what other ways can we have weapon stats. 
@export var weapon_abilities: Array[AbilityData]
@export var weapon_level: int = 1
