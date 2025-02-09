extends PlayerState
class_name PlayerIdleState

func enter() -> void:
	player.velocity = Vector2.ZERO
