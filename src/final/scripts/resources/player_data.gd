class_name PlayerData2
extends Resource

@export var speed = 45
@export var dash_speed_multiplier: float = 1.8
@export var dash_time: float = 0.5
@export var dash_cooldown: float = 1.0

@export var max_health: float = 10
@export var max_nutrition: float = 10

@export var interaction_range: float = 15.0

@export var inventory: PlayerInventory = PlayerInventory.new()
@export var equipped_weapon: WeaponData

@export var current_health: float = 10
@export var current_nutrition: float = 10
