extends Node2D
class_name Arrow

const SPEED = 300.0

var direction = Vector2(0,0)

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.receive_damage(2)
	queue_free()
	
func init(starting_position, target):
	# todo: is it possible to add it to the scene tree from here?
	position = starting_position
	look_at(target)
	rotate(deg_to_rad(90))
	direction = global_position.direction_to(target)

func _on_timer_timeout() -> void:
	queue_free()
