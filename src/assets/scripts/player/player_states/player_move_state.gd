extends PlayerState
class_name PlayerMoveState

#note: could be interesting if going up a hill actually made you be 'higher' and we made you sprite slightly bigger
# then smaller when going down
func handle_process(delta):
	weapon_animation()
	if player.global_position.distance_to(player.move_target) <= 5:
		player.move_target = player.global_position
		player.velocity = Vector2.ZERO
		Transitioned.emit(self, "Idle") #todo: something for state names like a constant? but it needs to match the node name?
	else:
		player.velocity = player.global_position.direction_to(player.move_target).normalized() * player.SPEED
		if player.is_hill:
			player.velocity = player.velocity / 2

# this needs to be closer to the weapon
# it makes sense the move state wants to make the weapon animate a certain way
# but it sucks for the move state to reach into the weapon like this.
# see idle too
func weapon_animation():
	if player.weapon_equipped and player.weapon.use_sprite:
		if player.velocity.x < 0:
			player.weapon.sprite.z_index = player.z_index - 1
			player.weapon.sprite.rotation_degrees = -75
			player.weapon.sprite.global_position = player.hand.global_position - Vector2(2,0)
		else:
			player.weapon.sprite.z_index = player.z_index
			player.weapon.sprite.rotation_degrees = 75
			player.weapon.sprite.global_position = player.hand.global_position + Vector2(2,0)
