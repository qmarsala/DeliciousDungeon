class_name DamageNumber
extends Label

@export var speed = 25
@onready var timer: Timer = $Timer

var direction

func _ready() -> void:
	timer.timeout.connect(_cleanup)
	direction = Vector2(randf_range(-.5,.5), -1)

func _process(delta: float) -> void:
	global_position += direction * speed * delta

func _cleanup():
	queue_free()
