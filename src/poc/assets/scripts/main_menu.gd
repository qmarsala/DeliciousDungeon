extends Node2D

var game_started: bool

func init(game_data: GameData):
	game_started = game_data.game_started

func _ready() -> void:
	if game_started:
		$Label.hide()
