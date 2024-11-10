extends EnemyState
class_name EnemyDeadState

#todo: can we tack this here or does it need to 
# be tracked on 'enemy'?
var is_dead = false

func handle_process(context: Enemy, delta: float):
	if is_dead:
		return
	is_dead = true
	context.animations.play("die")
	context.death_timer.start(.75)
	
func handle_physics_process(context: Enemy, delta: float):
	context.velocity = Vector2.ZERO
