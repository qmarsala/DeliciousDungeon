class_name WeaponData
extends ItemData

# for now weapons give armour - this is to help melee a bit
# I think later we will add some actual armour
@export var armour: float = 0
@export var evasion: float = 0

@export var max_range: float = 20
@export var cooldown_reduction: float = 0 # represents a perecentage subracted from cooldown
#what other ways can we have weapon stats. 
@export var weapon_abilities: Array[Ability]
@export var weapon_level: int = 1
