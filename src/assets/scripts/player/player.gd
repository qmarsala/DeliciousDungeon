class_name Player
extends CharacterBody2D

signal PlayerDied

const SPEED = 75.0
const DASH_MULTIPLIER = 2
const DASH_TIME = .5
const DASH_COOLDOWN = 1
const INTERACTION_RANGE = 15.0
const STARTING_NUTRITION = 10

@export var hunger_enabled: bool = true

@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var hand: Node2D = $Hand
@onready var interaction_ray_cast: RayCast2D = $InteractionRayCast
@onready var player_spell_sound: AudioStreamPlayer2D = $PlayerSpellSound

#todo: use 'pickup' to get a weapon that enables these attacks
@onready var magic_attack: MagicAttack = $MagicAttack
@onready var magic_attack_indicator: Sprite2D = $MagicAttackIndicator
@onready var move_destination_indicator: Sprite2D = $MoveIndicator
@onready var rest_timer: Timer = $RestTimer


var rest_is_cooldown = false
#todo: inventory
#this comes from 'game' don't like it, but poc'ing having player data outside of player
var player_items: Dictionary = {0:1,1:1}
var nutrition: float
var health: float: 
	get: return %HealthComponent.health

func is_dead(): 
	return %HealthComponent.is_dead()

var move_target: Vector2
var move_disabled: bool
var is_dashing: bool
var is_dash_cooldown: bool

#how else could we do this?
var is_hill: bool

#temp:
var weapon: Sprite2D
var weapon_equipped: bool

func _ready() -> void:
	nutrition = STARTING_NUTRITION
	move_target = global_position
	#todo: do more signal hook ups this way?
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timer_timeout)
	if Input.is_action_pressed("move"):
		move_disabled = true

func _process(delta: float) -> void:
	interaction_ray_cast.look_at(get_global_mouse_position())
	#todo: move this to ui layer?
	move_destination_indicator.global_position = move_target
	if global_position.distance_to(move_target) <= 5:
		move_destination_indicator.hide()
	if not weapon_equipped:
		magic_attack_indicator.hide()
	else:
		magic_attack_indicator.show()
		var magic_attack_pos = get_magic_attack_location()
		magic_attack_indicator.global_position = magic_attack_pos

func rest():
	if player_items[Enums.Items.Food] < 1 or rest_is_cooldown: return
	player_items[Enums.Items.Food] -= 1
	rest_is_cooldown = true
	rest_timer.start(30)
	nutrition = min(STARTING_NUTRITION, nutrition + STARTING_NUTRITION * .65)
	%HealthComponent.heal(%HealthComponent.starting_health * .35)
	$PlayerRestSound.play()

#todo: health component could have a hit box?
# but what about other ways of taking damage?
func receive_damage(damage):
	%HealthComponent.take_damage(damage)

func pickup(item: Item):
	print("picked up: " + item.name)
	if item is Weapon:
		var weaponScene = item.scene
		var weaponInstance = weaponScene.instantiate() as Sprite2D
		weapon = weaponInstance
		weapon_equipped = true
		hand.add_child.call_deferred(weaponInstance)
	else:
		player_items[item.item_id] += 1
	
func interact():
	var result = interaction_ray_cast.get_collider()
	if not result: return
	if Interfaces.is_interface(result, Interfaces.Interactable):
		result.interact(self)

func _on_hunger_timer_timeout() -> void:
	if not hunger_enabled or is_dead(): return
	if nutrition <= 0:
		receive_damage(1)
	else:
		nutrition = nutrition - 1

# todo: how could we encapsulate this in the magic attack component?
# need to check is dead before casting
func _on_magic_attack() -> void:
	if is_dead() or not weapon_equipped: return
	player_spell_sound.play()
	var target_location = get_magic_attack_location()
	magic_attack.cast_at_location(target_location)

func get_magic_attack_location() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	var target_location = mouse_pos
	if direction.length() > 75:
		target_location = global_position + (direction.normalized() * 75)
	return target_location

func _on_health_depleted() -> void:
	state_machine.transition_to("DeadState")
	
func _on_rest_timer_timeout() -> void:
	rest_is_cooldown = false

func _on_dash_timer_timeout() -> void:
	state_machine.transition_to("IdleState")
	
func _on_dash_cooldown_timer_timeout() -> void:
	is_dash_cooldown = false
