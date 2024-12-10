class_name Player
extends CharacterBody2D

signal PlayerDied

const SPEED = 75.0
const DASH_MULTIPLIER = 2
const DASH_TIME = .5
const DASH_COOLDOWN = 1
const INTERACTION_RANGE = 20.0
const STARTING_NUTRITION = 10

@export var hunger_enabled: bool = true
@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var death_timer: Timer = $DeathTimer
@onready var dash_timer: Timer = $DashTimer

#todo: use 'pickup' to get a weapon that enables these attacks
@onready var magic_attack: MagicAttack = $MagicAttack
@onready var magic_attack_indicator: Sprite2D = $MagicAttackIndicator
@onready var move_destination_indicator: Sprite2D = $MoveIndicator
@onready var rest_timer: Timer = $RestTimer

var rest_is_cooldown = false
var food: int
var nutrition: float
# todo: this feels like it ruins 'composition' adding health to the player
# but we need to be able to get at the health f a player from outside the player
var health: float: 
	get: return %HealthComponent.health
func is_dead(): return %HealthComponent.is_dead()

var move_target: Vector2
var move_disabled: bool
var is_dashing: bool
var is_dash_cooldown: bool

func _ready() -> void:
	nutrition = STARTING_NUTRITION
	move_target = global_position
	#todo: do more signal hook ups this way?
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	if Input.is_action_pressed("move"):
		move_disabled = true

func _process(delta: float) -> void:
	if is_dead(): return
	handle_interact_action()
	handle_movement_input(delta)
	handle_dash_input()
	#todo: move this to ui layer?
	var magic_attack_pos = get_magic_attack_location()
	magic_attack_indicator.global_position = magic_attack_pos
	move_destination_indicator.global_position = move_target

func handle_interact_action() -> void:
	#todo: this will be more than just opening a door
	if Input.is_action_just_pressed("interact"):
		var space_state = get_world_2d().direct_space_state
		var direction = get_global_mouse_position() - global_position
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + direction.normalized() * INTERACTION_RANGE)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if not result: return
		var target = result["collider"]
		if target and target is Door:
			target.open()

var time = 0
var pressed_at = 0
func handle_movement_input(delta):
	time += delta
	#todo: player state pattern?
	if is_dashing || move_disabled: return
	if move_disabled and Input.is_action_just_released("move"):
		move_disabled = false

	var mouse_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("move"):
		pressed_at = time
		move_target = mouse_pos
		move_destination_indicator.show()
	elif Input.is_action_pressed("move") and time - pressed_at > .1:
		move_target = mouse_pos
		move_destination_indicator.hide()
	elif Input.is_action_just_released("move"):
		move_destination_indicator.show()
	if global_position.distance_to(move_target) < 10:
		move_target = global_position
		velocity = Vector2.ZERO
		move_destination_indicator.hide()
	else:
		velocity = global_position.direction_to(move_target).normalized() * SPEED

func handle_dash_input():
	var mouse_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("dash") and not is_dash_cooldown:
		is_dashing = true
		is_dash_cooldown = true
		move_target = mouse_pos
		velocity = global_position.direction_to(move_target).normalized() * (SPEED * DASH_MULTIPLIER)
		dash_timer.start(DASH_TIME)

func rest():
	if food < 1 or rest_is_cooldown: return
	food-=1
	rest_is_cooldown = true
	rest_timer.start(30)
	nutrition = min(STARTING_NUTRITION, nutrition + STARTING_NUTRITION * .65)
	%HealthComponent.heal(%HealthComponent.starting_health * .35)

#todo: health component could have a hit box?
# but what about other ways of taking damage?
func receive_damage(damage):
	%HealthComponent.take_damage(damage)

func pickup(item: Item):
	print("picked up: " + item.name)
	food += 1

func _on_hunger_timer_timeout() -> void:
	if not hunger_enabled or is_dead(): return
	if nutrition <= 0:
		%HealthComponent.take_damage(1)
	else:
		nutrition = nutrition - 1

# todo: how could we encapsulate this in the magic attack component?
# need to check is dead before casting
func _on_magic_attack() -> void:
	if is_dead(): return
	var target_location = get_magic_attack_location()
	magic_attack.cast_at_location(target_location)

func get_magic_attack_location() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	var target_location = mouse_pos
	if direction.length() > 75:
		target_location = global_position + (direction.normalized() * 75)
	return target_location

func _on_rest_timer_timeout() -> void:
	rest_is_cooldown = false

func _on_health_depleted() -> void:
	death_timer.start(.75)

func _on_death_timer_timeout() -> void:
	PlayerDied.emit()
	
func _on_dash_timer_timeout() -> void:
	if not is_dashing and is_dash_cooldown:
		is_dash_cooldown = false
		dash_timer.stop()
	else:
		is_dashing = false
		move_target = global_position
		velocity = Vector2.ZERO
		move_destination_indicator.hide()
		dash_timer.stop()
		dash_timer.start(DASH_COOLDOWN - DASH_TIME)
