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
const STARTING_HEALTH = 10
const STARTING_NUTRITION = 10

@onready var aoe_area: Area2D = $AttackRayCast/AoeArea
@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var interact_ray_cast: RayCast2D = $InteractionRayCast
@onready var attack_ray_cast: RayCast2D = $AttackRayCast
@onready var death_timer: Timer = $DeathTimer
@onready var player_ui: PlayerUI = $PlayerUI

var health : float :
	get:
		return health
	set(v):
		health = v
		if player_ui:
			player_ui.update_health_bar(health)
var nutrition : float :
	get:
		return nutrition
	set(v):
		nutrition = v
		if player_ui:
			player_ui.update_hunger_bar(nutrition)
var is_dead = false

func _ready() -> void:
	health = STARTING_HEALTH
	nutrition = STARTING_NUTRITION

func _process(delta: float) -> void:
	if is_dead: return
	if health <= 0:
		character_sprite.stop()
		character_sprite.play("die")
		death_timer.start(.75)
		is_dead = true
		return
	var mouse_pos = get_global_mouse_position()
	attack_ray_cast.look_at(mouse_pos)
	interact_ray_cast.look_at(mouse_pos)
	handle_attack_action(delta)
	handle_interact_action()

func _physics_process(delta: float) -> void:
	if is_dead: return
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
	if character_sprite.is_playing() and character_sprite.animation == "receive_damage": return
	if xDirection == 0 and yDirection == 0:
		character_sprite.play("idle")
	else:
		character_sprite.flip_h = xDirection < 0
		character_sprite.play("run")

var cooldowns = {"basic_attack": BASIC_COOLDOWN, "charged_attack": CHARGED_COOLDOWN, "heavy_attack": HEAVY_COOLDOWN}
var damages = {"basic_attack": BASIC_DAMAGE, "charged_attack": CHARGED_DAMAGE, "heavy_attack": HEAVY_DAMAGE}
var basic_pressed_time : float = 0.0 : 
	get:
		return basic_pressed_time
	set(v):
		basic_pressed_time = v
		if player_ui and (basic_pressed_time >= (CHARGED_ATTACK_TIME * .25) or basic_pressed_time == 0):
			player_ui.update_charge_bar(basic_pressed_time)

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
		if attack_type == "charged_attack" and aoe_area.has_overlapping_bodies():
			var targets = aoe_area.get_overlapping_bodies() 
			for t in targets:
				t.receive_damage(damages[attack_type])
		elif attack_ray_cast.is_colliding():
			var target = attack_ray_cast.get_collider() 
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
		

func receive_damage(damage):
	health = health - damage
	character_sprite.stop()
	character_sprite.play("receive_damage")

func handle_interact_action() -> void:
	#todo: this will be more than just opening a door
	if Input.is_action_just_pressed("interact"):
		var target = interact_ray_cast.get_collider()
		if target and target is Door:
			target.open_door()

func rest():
	# for now this is really simple, be by a fire
	# later this will require food and cooking to be fully effective
	nutrition = STARTING_NUTRITION
	health = min(health + 2, STARTING_HEALTH)
	print("resting: ", nutrition, ", ", health)

func _on_cooldown_timer_timeout() -> void:
	attack_is_cooling_down = false

func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()

func _on_hunger_timer_timeout() -> void:
	if nutrition <= 0:
		receive_damage(1)
	else:
		nutrition = nutrition - 1
