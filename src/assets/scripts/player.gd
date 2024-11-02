extends CharacterBody2D

const SPEED = 100.0
const INTERACTION_RANGE = 20.0
const CHARGED_ATTACK_TIME = .5
const BASIC_COOLDOWN = .3
const BASIC_DAMAGE = 1
const CHARGED_COOLDOWN = 0
const CHARGED_DAMAGE = 1.75
const HEAVY_COOLDOWN = .7
const HEAVY_DAMAGE = 2.5

@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var interact_cast: RayCast2D = $InteractionRayCast

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	interact_cast.look_at(mouse_pos)
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


var cooldowns = {"basic_attack": BASIC_COOLDOWN, "charged_attack": CHARGED_COOLDOWN, "heavy_attack": HEAVY_COOLDOWN}
var damages = {"basic_attack": BASIC_DAMAGE, "charged_attack": CHARGED_DAMAGE, "heavy_attack": HEAVY_DAMAGE}
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
		var attack_type = get_attack_type(basic_attack_released, heavy_attack_released)
		cooldown_timer.start(cooldowns[attack_type])
		if interact_cast.is_colliding():
			var target = interact_cast.get_collider() 
			target.receive_damage(damages[attack_type])

func get_attack_type(basic_attack, heavy_attack) -> String:
	var total_time_charged = basic_pressed_time
	basic_pressed_time = 0
	if basic_attack and total_time_charged > CHARGED_ATTACK_TIME: 
		return "charged_attack"
	elif heavy_attack:
		return "heavy_attack"
	else:
		return "basic_attack"

func _on_cooldown_timer_timeout() -> void:
	attack_is_cooling_down = false
