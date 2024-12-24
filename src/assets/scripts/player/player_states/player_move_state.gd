extends PlayerState
class_name PlayerMoveState

func handle_process(delta): 
	weapon_animation()
	if player.global_position.distance_to(player.move_target) <= 5:
		player.move_target = player.global_position
		player.velocity = Vector2.ZERO
		Transitioned.emit(self, "IdleState") #todo: something for state names like a constant? but it needs to match the node name?
	else:
		player.velocity = player.global_position.direction_to(player.move_target).normalized() * player.SPEED
		if player.is_hill:
			player.velocity = player.velocity / 2 

func weapon_animation():
	if player.weapon_equipped and player.weapon:
		if player.velocity.x < 0:
			player.weapon.z_index = player.z_index - 1
			player.weapon.rotation_degrees = -75
			player.weapon.global_position = player.hand.global_position - Vector2(2,0)
		else:
			player.weapon.z_index = player.z_index + 1
			player.weapon.rotation_degrees = 75
			player.weapon.global_position = player.hand.global_position + Vector2(2,0)
		
