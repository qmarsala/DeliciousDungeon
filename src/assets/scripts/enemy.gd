extends CharacterBody2D
class_name Enemy

const STARTING_HP = 5
const SPEED = 100.0
const MIN_DISTANCE = 15
const ATTACK_COOLDOWN = 1

@onready var animations: AnimatedSprite2D = $Animations

var health = STARTING_HP
var is_dead = false

func _process(delta: float) -> void:
	is_dead = health <= 0

func _physics_process(delta: float) -> void:
	if is_dead: return
	move_and_slide()
	play_animation()

func play_animation():
	if velocity.length() > 0:
		animations.play("run")
	else:
		animations.play("idle")
	animations.flip_h = velocity.x > 0

func receive_damage(damage):
	if is_dead: return
	animations.stop()
	animations.play("receive_damage")
	health -= damage
	print("taking ", damage, " health:", health)

func _on_death_timer_timeout() -> void:
	queue_free()
