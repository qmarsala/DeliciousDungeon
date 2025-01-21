class_name PlayerData
extends Resource

@export var items: Dictionary = {}
@export var starting_health: float = 15
@export var starting_nutrition: float = 10
@export var max_health: float = 15
@export var max_nutrition: float = 10
@export var health: float = 15
@export var nutrition: float = 10
@export var speed: float = 60
# dash as an ability?
@export var dash_speed: float = 1.75
@export var dash_time: float = .5
@export var dash_cooldown: float = 1

@export var interaction_range: float = 15.0

# do we need to persist these at all?
# the active quest reward buff will need to be remembered for sure
# is that an effect?

#@export var weapon: Item
#@export var status_effects: Array[StatusEffect]

func reset_nutrition():
	nutrition = starting_nutrition

func reset_health():
	nutrition = starting_health
