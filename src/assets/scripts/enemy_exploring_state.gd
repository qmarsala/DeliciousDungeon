extends EnemyState
class_name EnemyExploringState

func handle_process(context: Enemy, delta: float):
	context.animations.play("run")

func handle_physics_process(context: Enemy, delta: float):
	var direction = context.explore_direction.normalized()
	var velocity = direction * (context.SPEED / 2)
	context.velocity = velocity
	context.explore_ray_cast.target_position = context.velocity.normalized() * context.MIN_DISTANCE
	if context.explore_ray_cast.get_collider():
		context.velocity = Vector2.ZERO
		context.explore_direction = -direction
