class_name InteractBox
extends Area2D

signal interacted(Player)

func _ready() -> void:
	add_to_group(Interfaces.Interactable)

func interact(player: Player) -> void:
	interacted.emit(player)
