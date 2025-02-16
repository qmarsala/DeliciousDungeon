class_name PlayerAimController
extends RefCounted


func get_aim_direction() -> Vector2:
	return Vector2(get_x_input(), get_y_input()).normalized()

# is Input the right thing to use? or _unhandled_input with InputEvent?
func get_x_input() -> float:
	return Input.get_axis("aim_west", "aim_east")

func get_y_input() -> float:
	return Input.get_axis("aim_north", "aim_south")
