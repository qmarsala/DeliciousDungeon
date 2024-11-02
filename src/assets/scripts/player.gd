extends CharacterBody2D

const SPEED = 100.0
const CHARGED_ATTACK_TIME = .5
const BASIC_COOLDOWN = .3
const CHARGED_COOLDOWN = 0
const HEAVY_COOLDOWN = .7

@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var cooldown_timer: Timer = $CooldownTimer


func _process(delta: float) -> void:
	handle_attack_action(delta)

func _physics_process(delta: float) -> void:
	var xDirection = get_x_input()
	var yDirection = get_y_input()
	velocity = calc_player_velocity(xDirection, yDirection)
	play_animation(xDirection, yDirection)
	move_and_slide()

func get_x_input():
	var xDirection := Input.get_axis("move_west", "move_east")
	if xDirection:
		return xDirection
	else:
		return move_toward(velocity.x, 0, SPEED)

func get_y_input():
	var yDirection = Input.get_axis("move_north", "move_south")
	if yDirection:
		return yDirection
	else:
		return move_toward(velocity.y, 0, SPEED)

func calc_player_velocity(xDirection, yDirection):
	return Vector2(xDirection, yDirection).normalized() * SPEED

func play_animation(xDirection, yDirection): 
	if xDirection == 0 and yDirection == 0:
		character_sprite.play("idle")
	else:
		character_sprite.flip_h = xDirection < 0
		character_sprite.play("run")

var basic_pressed_time = 0
var attack_is_cooling_down = false
func handle_attack_action(delta):
	if attack_is_cooling_down:
		return
	if Input.is_action_pressed("basic_attack"):
		basic_pressed_time += delta
		
	var basic_attack_released = Input.is_action_just_released("basic_attack")
	var heavy_attack_released = Input.is_action_just_released("heavy_attack")
	var attack_released = basic_attack_released or heavy_attack_released
	if attack_released:
		attack_is_cooling_down = true
		attack_target(basic_attack_released, heavy_attack_released, "todo")

func attack_target(basic_attack_released, heavy_attack_released, target):
	if basic_attack_released:
		if basic_pressed_time > CHARGED_ATTACK_TIME: 
			cooldown_timer.start(CHARGED_COOLDOWN)
			print("charged_attack")
		else:
			cooldown_timer.start(BASIC_COOLDOWN)
			print("basic_attack")
		basic_pressed_time = 0
	if heavy_attack_released:
		cooldown_timer.start(HEAVY_COOLDOWN)
		print("heavy_attack")

func _on_cooldown_timer_timeout() -> void:
	attack_is_cooling_down = false
