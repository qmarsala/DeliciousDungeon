class_name DestinationMarker
extends Sprite2D

@export var speed = 100

var switched_at: float = 0
var direction = Vector2.DOWN
var pos: Vector2
var time: float = 0
func _process(delta: float):
	time += delta
	if time - switched_at > .5: 
		switched_at = time
		direction.y *= -1
	global_position = pos + direction * delta * speed 

func show_at(position: Vector2):
	pos = position
	if not visible:
		direction = Vector2.DOWN
		switched_at = time
		show()
