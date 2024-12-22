extends Node2D

@export var player_scene: PackedScene

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.PlayerDied.connect(_on_player_died)

func _on_player_died() -> void:
	get_tree().reload_current_scene()
