extends Node2D
class_name Arrow

const SPEED = 100.0

var direction = Vector2(0,0)

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.receive_damage(2)
	queue_free()
	
func shoot_arrow(starting_pos, target):
	# todo: is it possible to add it to the scene tree from here?
	position = starting_pos
	direction = global_position.direction_to(target)
