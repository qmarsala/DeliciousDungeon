extends PlayerState
class_name PlayerMoveState

func handle_process(delta): 
	handle_interact_action()
	if player.global_position.distance_to(player.move_target) <= 5:
		player.move_target = player.global_position
		player.velocity = Vector2.ZERO
		Transitioned.emit(self, "IdleState") #todo: something for state names like a constant? but it needs to match the node name?
	else:
		player.velocity = player.global_position.direction_to(player.move_target).normalized() * player.SPEED
