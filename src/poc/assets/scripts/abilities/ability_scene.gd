class_name AbilityScene
extends Node2D

var data: AbilityData
var starting_position: Vector2
var target_position: Vector2
var direction: Vector2

func init(ability_data: AbilityData, start: Vector2, target: Vector2) -> void:
	starting_position = start
	target_position = target
	direction = starting_position.direction_to(target)
	global_position = starting_position
	data = ability_data.duplicate()
	initialized()

func initialized():
	pass
