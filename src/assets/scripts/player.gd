extends CharacterBody2D
class_name Player

const SPEED = 75.0
const INTERACTION_RANGE = 20.0
const STARTING_HEALTH = 10
const STARTING_NUTRITION = 10

@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var death_timer: Timer = $DeathTimer
@onready var player_ui: PlayerUI = $PlayerUI
@onready var ranged_attack: RangedAttack = $RangedAttack
@onready var melee_attack: MeleeAttack = $MeleeAttack
@onready var magic_attack: MagicAttack = $MagicAttack
@onready var rest_timer: Timer = $RestTimer

var rest_is_cooldown = false

var food : int : 
	get:
		return food
	set(v):
		food = v
		if player_ui:
			player_ui.update_food_count(food)

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
var move_target

func _ready() -> void:
	health = STARTING_HEALTH
	nutrition = STARTING_NUTRITION
	move_target = global_position

func _process(delta: float) -> void:
	if is_dead: return
	
	if health <= 0:
		character_sprite.stop()
		character_sprite.play("die")
		death_timer.start(.75)
		is_dead = true
		return
	var mouse_pos = get_global_mouse_position()
	if Input.is_action_pressed("move"):
		move_target = mouse_pos

func _physics_process(delta: float) -> void:
	if is_dead: return
	handle_interact_action()
	if global_position.distance_to(move_target) < 10:
		move_target = global_position
		velocity = Vector2.ZERO
	else:
		velocity = global_position.direction_to(move_target).normalized() * SPEED
	play_animation()
	move_and_slide()

func play_animation():
	if character_sprite.is_playing() and character_sprite.animation == "receive_damage": return
	if velocity.length() == 0:
		character_sprite.play("idle")
	else:
		character_sprite.flip_h = velocity.x < 0
		character_sprite.play("run")

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
			target.open_door()

func receive_damage(damage):
	health = health - damage
	character_sprite.stop()
	character_sprite.play("receive_damage")

func rest():
	if food < 1 or rest_is_cooldown: return
	food-=1
	rest_is_cooldown = true
	rest_timer.start(30)
	nutrition = STARTING_NUTRITION
	health = min(health + 2, STARTING_HEALTH)
	print("resting: ", nutrition, ", ", health)

func pickup_food():
	food += 1

func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()

func _on_hunger_timer_timeout() -> void:
	if nutrition <= 0:
		receive_damage(1)
	else:
		nutrition = nutrition - 1

func _on_ranged_attack_charge(value: float) -> void:
	if is_dead: return
	player_ui.update_charge_bar(value)

func _on_ranged_attack() -> void:
	if is_dead: return
	ranged_attack.shoot_projectile(position, get_global_mouse_position())

func _on_magic_attack() -> void:
	if is_dead: return
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	var target_location = mouse_pos
	# why does this not work?!
	if direction.length() > 75:
		target_location = global_position + (direction.normalized() * 75)
	magic_attack.cast_at_location(target_location)

func _on_melee_attack(attack_type: String) -> void:
	if is_dead: return
	melee_attack.swing(attack_type)

func _on_magic_attack_charge(value: float) -> void:
	if is_dead: return
	player_ui.update_charge_bar(value)


func _on_rest_timer_timeout() -> void:
	rest_is_cooldown = false
