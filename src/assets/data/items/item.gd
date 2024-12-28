class_name Item
extends Resource

@export var item_id: Enums.Items
@export var scene: PackedScene
@export var name: String
@export var description: String
#bleh - but trying to avoid circular ref
@export var is_weapon: bool
@export var weapon_data: WeaponData
