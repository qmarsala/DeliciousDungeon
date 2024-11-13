extends EnemyState
class_name EnemyFightingState

func handle_process(context: Enemy, delta: float):
	if context.attack_is_cooling_down or not context.player_is_visible:
		return
	context.cooldown_timer.start(context.ATTACK_COOLDOWN)
	context.attack_is_cooling_down = true
	context.melee_range.look_at(context.target.global_position)
	var target = context.melee_range.get_collider()
	if target:
		target.receive_damage(1.5)

func handle_physics_process(context: Enemy, delta: float):
	if context.player_is_in_range:
		context.velocity = Vector2.ZERO
		return
	var direction = context.global_position.direction_to(context.target.global_position)
	context.velocity = direction.normalized() * context.SPEED
	
