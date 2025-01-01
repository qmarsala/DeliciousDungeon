extends Node2D

var character: Player

func _ready() -> void:
	# I feel this is safe to assume hands.
	character = get_parent() as Player
	z_as_relative = false

func _process(delta: float) -> void:
	if not is_instance_valid(character): return
	var direction = character.get_global_mouse_position() - character.global_position
	if direction.length() > 4:
		position = (direction.normalized() * 4) + Vector2(0,2)
	else:
		position = character.global_position + Vector2(0, 2)
	if position.y < 0:
		z_index = character.z_index - 1
	else:
		z_index = character.z_index + 1
