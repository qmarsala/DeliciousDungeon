class_name DungeonManager
extends Node2D

var player: Player
var current_floor: int = 0

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is Player:
			player = child
			break
	#todo: store floor in game state so we can increment it
	$Rooms.generate_floor(current_floor)
