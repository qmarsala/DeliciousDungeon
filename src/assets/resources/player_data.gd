class_name PlayerData
extends Resource


@export var items: Dictionary
@export var starting_health: float
@export var starting_nutrition: float
@export var max_health: float
@export var max_nutrition: float
@export var health: float
@export var nutrition: float
@export var speed: float
# dash as an ability?
@export var dash_speed: float = 1.75
@export var dash_time: float = .5
@export var dash_cooldown: float = 1

@export var interaction_range: float = 15.0

@export var weapon: Item
@export var status_effects: Array[StatusEffect]

func reset_nutrition():
	nutrition = starting_nutrition

func reset_health():
	nutrition = starting_health
