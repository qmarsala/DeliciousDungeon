class_name Player
extends CharacterBody2D

const SPEED = 75.0
const INTERACTION_RANGE = 20.0
const STARTING_NUTRITION = 10

@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var death_timer: Timer = $DeathTimer

#todo: use 'pickup' to get a weapon that enables these attacks
@onready var magic_attack: MagicAttack = $MagicAttack
@onready var magic_attack_indicator: Sprite2D = $MagicAttackIndicator
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

func _ready() -> void:
	nutrition = STARTING_NUTRITION
	move_target = global_position

func _process(delta: float) -> void:
	if is_dead(): return
	handle_interact_action()
	handle_movement_input()
	#todo: move this to ui layer?
	var magic_attack_pos = get_magic_attack_location()
	magic_attack_indicator.global_position = magic_attack_pos

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

func handle_movement_input():
	var mouse_pos = get_global_mouse_position()
	if Input.is_action_pressed("move"):
		move_target = mouse_pos
	if global_position.distance_to(move_target) < 10:
		move_target = global_position
		velocity = Vector2.ZERO
	else:
		velocity = global_position.direction_to(move_target).normalized() * SPEED

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
	get_tree().reload_current_scene()
