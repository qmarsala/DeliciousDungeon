extends PlayerState
class_name PlayerDashState

var dash_velocity: Vector2
var dashed_at: float
var post_dash_move: bool
var post_dash_move_target: Vector2
func enter():
	post_dash_move = false
	player.set_collision_layer_value(2, false)
	player.set_collision_mask_value(3, false)
	player.is_dash_cooldown = true
	player.dash_timer.start(player.DASH_TIME)
	player.character_sprite.play("dash")
	if player.weapon_equipped:
		player.weapon.hide()
	dash_velocity = calculate_dash_velocity()
	dashed_at = time

func calculate_dash_velocity() -> Vector2:
	return player.global_position.direction_to(player.move_target).normalized() * (player.SPEED * player.DASH_MULTIPLIER)

func handle_process(delta):
	if player.is_hill:
		player.velocity = dash_velocity / 3
	else:
		player.velocity = dash_velocity
	if time - dashed_at >= player.DASH_TIME:
		Transitioned.emit(self, "Move")

func exit():
	player.set_collision_layer_value(2, true)
	player.set_collision_mask_value(3, true)
	if !post_dash_move:
		player.move_target = player.global_position
		player.move_destination_indicator.hide()
	else:
		player.move_target = post_dash_move_target
		player.move_destination_indicator.show()
	player.dash_cooldown_timer.start(player.DASH_COOLDOWN)
	player.character_sprite.stop()
	if player.weapon_equipped:
		player.weapon.show()

func handle_movement_input(event: InputEvent):
	if event.is_action_pressed("move"):
		post_dash_move = true
		post_dash_move_target = player.get_global_mouse_position()
