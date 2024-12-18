extends PlayerState
class_name PlayerDashState

var dash_velocity

func enter():
	player.set_collision_layer_value(2, false)
	player.set_collision_mask_value(3, false)
	player.is_dash_cooldown = true
	player.dash_timer.start(player.DASH_TIME)
	player.character_sprite.play("dash")
	if player.weapon_equipped:
		player.weapon.hide()
	dash_velocity = calculate_dash_velocity()

func calculate_dash_velocity() -> Vector2:
	return player.global_position.direction_to(player.move_target).normalized() * (player.SPEED * player.DASH_MULTIPLIER)

func handle_process(delta):
	if player.is_hill:
		player.velocity = dash_velocity / 3
	else:
		player.velocity = dash_velocity

func exit():
	player.set_collision_layer_value(2, true)
	player.set_collision_mask_value(3, true)
	player.move_target = player.global_position
	player.velocity = Vector2.ZERO
	player.move_destination_indicator.hide()
	player.dash_timer.stop()
	player.dash_cooldown_timer.start(player.DASH_COOLDOWN)
	player.character_sprite.stop()
	if player.weapon_equipped:
		player.weapon.show()

func handle_physics_process(delta: float) -> void:
	pass
