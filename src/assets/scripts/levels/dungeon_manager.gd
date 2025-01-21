class_name DungeonManager
extends Node2D

var player: Player
var current_floor: int = 6

func init(game_data: GameData): 
	current_floor = game_data.current_floor

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is Player:
			player = child
			break
	$Rooms.generate_floor(current_floor)
