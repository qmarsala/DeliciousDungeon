extends PlayerState
class_name PlayerMoveState

#note: could be interesting if going up a hill actually made you be 'higher' and we made you sprite slightly bigger
# then smaller when going down
func handle_process(delta):
	if player.global_position.distance_to(player.move_target) <= 5:
		player.move_target = player.global_position
		Transitioned.emit(self, "Idle") #todo: something for state names like a constant? but it needs to match the node name?
	else:
		player.velocity = player.global_position.direction_to(player.move_target).normalized() * player.player_data.speed
		if player.is_hill:
			player.velocity = player.velocity / 2
