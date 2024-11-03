extends CharacterBody2D
class_name Enemy

const STARTING_HP = 5
const SPEED = 100.0

@onready var animations: AnimatedSprite2D = $Animations
@onready var timer: Timer = $Timer

var health = STARTING_HP
var is_dead = false
var player_is_visible = false
var player

func _process(delta: float) -> void:
	if is_dead: return
	if health <= 0:
		animations.play("die")
		timer.start(.75)
		is_dead = true
		return

	if not animations.is_playing():
		animations.play("idle")


func _physics_process(delta: float) -> void:
	if is_dead or not player_is_visible:
		return 
	var direction = global_position.direction_to(player.global_position)
	velocity = direction.normalized() * SPEED
	move_and_slide()


func receive_damage(damage):
	if is_dead: return 

	animations.play("receive_damage")
	health -= damage
	print("taking ", damage, " health:", health)

func _on_timer_timeout() -> void:
	queue_free()


func _on_vison_area_body_entered(body: Node2D) -> void:
	player_is_visible = true
	player = body
	print("see player")


func _on_vison_area_body_exited(body: Node2D) -> void:
	player_is_visible = false
	print("player is gone")
