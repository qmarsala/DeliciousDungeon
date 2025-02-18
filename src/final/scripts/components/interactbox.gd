class_name InteractBox
extends Area2D

signal interacted(Player)

func interact(player: Player) -> void:
	interacted.emit(player)
