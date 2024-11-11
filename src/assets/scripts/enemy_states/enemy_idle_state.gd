extends EnemyState
class_name EnemyIdleState

func handle_process(context: Enemy, delta: float):
	context.animations.play("idle")
	
func handle_physics_process(context: Enemy, delta: float):
	context.velocity = Vector2.ZERO
