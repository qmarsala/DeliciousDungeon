class_name GameScene
extends Node2D

var level: int = 0
var player: Player2
var player_data: PlayerData2

func init(player_data: PlayerData2, current_level: int = 0) -> void:
	level = current_level
	self.player_data = player_data

func _ready():
	player = get_tree().get_first_node_in_group("Player") as Player2
	player.init(player_data)
