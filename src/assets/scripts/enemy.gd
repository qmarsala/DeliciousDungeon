extends Node
class_name Enemy

const STARTING_HP = 5

@onready var animations: AnimatedSprite2D = $Animations
@onready var timer: Timer = $Timer

var health = STARTING_HP
var is_dead = false

func _process(delta: float) -> void:
	if is_dead: return
	if health <= 0:
		animations.play("die")
		timer.start(.75)
		is_dead = true
		return

	if not animations.is_playing():
		animations.play("idle")

func receive_damage(damage):
	if is_dead: return 

	animations.play("receive_damage")
	health -= damage
	print("taking ", damage, " health:", health)

func _on_timer_timeout() -> void:
	queue_free()
