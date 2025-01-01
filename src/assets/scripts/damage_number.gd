class_name DamageNumber
extends Label

@export var speed = 25
@onready var timer: Timer = $Timer

var direction

func init(damage: float, position: Vector2, target_is_player: bool):
	text = String.num(damage)
	global_position = position
	direction = Vector2(randf_range(-.5,.5), -1)
	if target_is_player:
		modulate = Color("fd5469")
		direction *= -1

func _ready() -> void:
	timer.timeout.connect(_cleanup)

func _process(delta: float) -> void:
	global_position += direction * speed * delta

func _cleanup():
	queue_free()
