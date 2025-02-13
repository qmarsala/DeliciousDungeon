class_name PlayerMovementController
extends RefCounted

var speed = 45.0

func init(player_speed: float):
	speed = player_speed

func get_velocity(current_velocity: Vector2) -> Vector2:
	var xDirection = get_x_input(current_velocity)
	var yDirection = get_y_input(current_velocity)
	var velocity = calc_player_velocity(xDirection, yDirection)
	return velocity

# is Input the right thing to use? or _unhandled_input with InputEvent?
func get_x_input(current_velocity: Vector2):
	var xDirection := Input.get_axis("move_west", "move_east")
	if xDirection:
		return xDirection
	else:
		return move_toward(current_velocity.x, 0, speed)

func get_y_input(current_velocity: Vector2):
	var yDirection = Input.get_axis("move_north", "move_south")
	if yDirection:
		return yDirection
	else:
		return move_toward(current_velocity.y, 0, speed)

func calc_player_velocity(xDirection, yDirection):
	return Vector2(xDirection, yDirection).normalized() * speed
