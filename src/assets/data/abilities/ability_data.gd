class_name AbilityData
extends Resource

@export var has_scene: bool
@export var scene: PackedScene

@export var target_self: bool

@export var cast_time = .3
@export var cooldown = 1.3
@export var damage: Array[float] = [1]
@export var status_effects: Array[StatusEffect]

# this feels like its in the wrong spot
@export var input_event = "ability_one"
