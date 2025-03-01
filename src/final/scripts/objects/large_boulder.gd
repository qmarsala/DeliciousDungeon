extends StaticBody2D

@export var spawn_chance: float = .33

func _ready() -> void:
	if randf() > spawn_chance:
		queue_free()
		return
