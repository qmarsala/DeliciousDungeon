extends Node2D

func _ready() -> void:
	if GameManager.game_started:
		$Label.hide()
