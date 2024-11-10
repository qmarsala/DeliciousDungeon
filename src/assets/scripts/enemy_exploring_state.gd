extends EnemyState
class_name EnemyExploringState

func handle_process(context: Enemy, delta: float):
	context.animations.play("run")

func handle_physics_process(context: Enemy, delta: float):
	context.velocity = context.explore_direction.normalized() * (context.SPEED / 2)
