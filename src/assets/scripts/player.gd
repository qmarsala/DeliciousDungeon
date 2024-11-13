extends CharacterBody2D

const SPEED = 100.0
const INTERACTION_RANGE = 20.0
const STARTING_HEALTH = 10
const STARTING_NUTRITION = 10

@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var interact_ray_cast: RayCast2D = $InteractionRayCast
@onready var death_timer: Timer = $DeathTimer
@onready var player_ui: PlayerUI = $PlayerUI
@onready var ranged_attack: RangedAttack = $RangedAttack
@onready var melee_attack: MeleeAttack = $MeleeAttack
@onready var magic_attack: MagicAttack = $MagicAttack
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


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
	if Input.is_action_just_pressed("interact"):
		print(navigation_agent.is_target_reachable())
		print(navigation_agent.is_navigation_finished())
	if is_dead: return
	if health <= 0:
		character_sprite.stop()
		character_sprite.play("die")
		death_timer.start(.75)
		is_dead = true
		return
	var mouse_pos = get_global_mouse_position()
	interact_ray_cast.look_at(mouse_pos)
	handle_interact_action()

func _physics_process(delta: float) -> void:
	if is_dead: return
	if Input.is_action_pressed("move"):
		var mouse_pos = get_global_mouse_position()
		navigation_agent.target_position = mouse_pos
	if navigation_agent.is_navigation_finished():
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))
		character_sprite.play("idle")
	else:
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()).normalized() * SPEED
		character_sprite.play("run")
	#var xDirection = get_x_input()
	#var yDirection = get_y_input()
	#velocity = calc_player_velocity(xDirection, yDirection)
	#play_animation(xDirection, yDirection)
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

func handle_interact_action() -> void:
	#todo: this will be more than just opening a door
	if Input.is_action_just_pressed("interact"):
		var target = interact_ray_cast.get_collider()
		if target and target is Door:
			target.open_door()

func receive_damage(damage):
	health = health - damage
	character_sprite.stop()
	character_sprite.play("receive_damage")

func rest():
	# for now this is really simple, be by a fire
	# later this will require food and cooking to be fully effective
	nutrition = STARTING_NUTRITION
	health = min(health + 2, STARTING_HEALTH)
	print("resting: ", nutrition, ", ", health)

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
	magic_attack.cast_at_location(get_global_mouse_position())

func _on_melee_attack(attack_type: String) -> void:
	if is_dead: return
	melee_attack.swing(attack_type)

func _on_magic_attack_charge(value: float) -> void:
	if is_dead: return
	player_ui.update_charge_bar(value)
