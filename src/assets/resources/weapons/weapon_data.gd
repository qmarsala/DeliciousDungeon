class_name WeaponData
extends ItemData

@export var max_range: float
@export var cooldown_reduction: float = 0 # represents a perecentage subracted from cooldown
#what other ways can we have weapon stats. 
# if this is an array of ability data, where would the scene be found?
@export var weapon_abilities: Array[Ability]
@export var weapon_level: int = 1
