class_name InteractBox
extends Area2D

signal interacted(Player2)

func interact(player: Player2) -> void:
	interacted.emit(player)
