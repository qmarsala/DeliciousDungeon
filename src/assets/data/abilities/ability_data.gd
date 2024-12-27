class_name AbilityData
extends Resource

@export var has_scene: bool
@export var scene: PackedScene

@export var target_self: bool

@export var cast_time = .25
@export var cooldown = 1.0
@export var input_event = "ability_one"
@export var damage: Array[float] = [1]
@export var status_effects: Array[StatusEffect]
