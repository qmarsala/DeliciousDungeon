extends EnemyState
class_name EnemyDeadState

func handle_process(context: Enemy, delta: float):
	if context.is_dead:
		return
	context.is_dead = true
	context.animations.play("die")
	context.death_timer.start(.75)
	
func handle_physics_process(context: Enemy, delta: float):
	context.velocity = Vector2.ZERO
