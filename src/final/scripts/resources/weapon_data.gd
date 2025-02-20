class_name WeaponData2
extends Resource

@export var name: String = "Unarmed"
@export var description: String = ""
@export var sprite: AtlasTexture
@export var weapon_type: Enums.WeaponTypes = Enums.WeaponTypes.Melee
@export var max_range: float = 20

@export var weapon_level: int
# can these three be a function of weapon level?
@export var defense: float = 0
@export var attack_power: float = 1
@export var speed: float = 0
