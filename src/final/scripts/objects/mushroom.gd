class_name Mushroom
extends Node2D

@export var spawn_chance: float = 1

@onready var orange: Sprite2D = $Orange
@onready var brown: Sprite2D = $Brown
@onready var interactbox: InteractBox = $Interactbox

func _ready() -> void:
	if randf() > spawn_chance:
		queue_free()
		return

	interactbox.interacted.connect(interact)
	
	var size = randf_range(0.85, 1.15)
	apply_scale(Vector2(size, size))
	
	var should_be_orange = randf() >= .5
	if should_be_orange:
		brown.hide()
	else:
		orange.hide()

#todo: spawn mushroom item for cooking
func interact(player: Player2):
	print("picking mushroom")
	player.pickup()
