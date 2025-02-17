class_name PlayerData2
extends Resource

@export var stats: PlayerStats = PlayerStats.new()
@export var inventory: PlayerInventory = PlayerInventory.new()

@export var health: float = 10
@export var nutrition: float = 10

@export var equipped_weapon: WeaponData
