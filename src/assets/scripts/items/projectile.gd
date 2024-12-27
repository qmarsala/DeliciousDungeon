extends Node2D
class_name Projectile

@export var speed = 300.0
@export var damage = 2

var direction = Vector2(0,0)
var target = Vector2(0,0)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func init(starting_position, target_position):
	# todo: is it possible to add it to the scene tree from here?
	position = starting_position
	target = target_position
	direction = global_position.direction_to(target)
	face_target()

# this should just be look at target, 
# not sure why I need the extra rotate
# rotating first in the arrow scene doesn't do anything
func face_target():
	look_at(target)
	rotate(deg_to_rad(90))

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group(Interfaces.Damageable):
		area.receive_damage(damage)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(Interfaces.Damageable):
		body.receive_damage(damage)
	queue_free()
