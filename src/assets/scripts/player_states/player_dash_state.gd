extends PlayerState
class_name PlayerDashState

func enter():
	print("dash")
	player.is_dash_cooldown = true
	player.velocity = player.global_position.direction_to(player.move_target).normalized() * (player.SPEED * player.DASH_MULTIPLIER)
	player.dash_timer.start(player.DASH_TIME)
	player.character_sprite.play("dash")

func exit():
	player.move_target = player.global_position
	player.velocity = Vector2.ZERO
	player.move_destination_indicator.hide()
	player.dash_timer.stop()
	player.dash_cooldown_timer.start(player.DASH_COOLDOWN)
	player.character_sprite.stop()

func handle_movement_input(delta):
	pass
