class_name MoveIdicator
extends Sprite2D

@export var speed = 100

var time: float = 0
var switched_at: float = 0
var direction = Vector2.UP

func _process(delta: float):
	time += delta
	if time - switched_at > .5: 
		switched_at = time
		direction.y *= -1
	global_position += direction * delta * speed 
