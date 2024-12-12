extends PlayerState
class_name PlayerDashState

func enter():
	print("dash")
	player.set_collision_layer_value(2, false)
	player.set_collision_mask_value(3, false)
	player.is_dash_cooldown = true
	player.velocity = player.global_position.direction_to(player.move_target).normalized() * (player.SPEED * player.DASH_MULTIPLIER)
	player.dash_timer.start(player.DASH_TIME)
	player.character_sprite.play("dash")
	

func exit():
	player.set_collision_layer_value(2, true)
	player.set_collision_mask_value(3, true)
	player.move_target = player.global_position
	player.velocity = Vector2.ZERO
	player.move_destination_indicator.hide()
	player.dash_timer.stop()
	player.dash_cooldown_timer.start(player.DASH_COOLDOWN)
	player.character_sprite.stop()


func handle_movement_input(delta):
	pass
