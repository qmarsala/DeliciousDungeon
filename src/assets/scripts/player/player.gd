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
# if hills go east west we may also want to pitch the angle of movement
var is_hill: bool

#temp:
var weapon: Weapon
var weapon_equipped: bool

func _ready() -> void:
	nutrition = STARTING_NUTRITION
	move_target = global_position
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timer_timeout)
	add_to_group(Interfaces.Damageable)
	if Input.is_action_pressed("move"):
		move_disabled = true

func _process(delta: float) -> void:
	interaction_ray_cast.look_at(get_global_mouse_position())
	#todo: move this to ui layer?
	move_destination_indicator.global_position = move_target
	if global_position.distance_to(move_target) <= 5:
		move_destination_indicator.hide()

func rest():
	if player_items[Enums.Items.Food] < 1 or rest_is_cooldown: return
	player_items[Enums.Items.Food] -= 1
	rest_is_cooldown = true
	rest_timer.start(30)
	SignalBusService.ActionPerformed.emit(Enums.Actions.Rest)
	nutrition = min(STARTING_NUTRITION, nutrition + STARTING_NUTRITION * .65)
	%HealthComponent.heal(%HealthComponent.starting_health * .35)
	$PlayerRestSound.play()

# was hoping component would limit needing to alter parents, but 
# you still need to if the parent needs to expose the method
# and to hook up signals
# is this just the way it is?
func receive_damage(damage: float):
	%HealthComponent.receive_damage(damage)

func pickup(item: Item):
	print("picked up: " + item.data.name)
	if item.data is WeaponData:
		equip(item)
	else:
		player_items[item.data.item_id] += 1

func equip(item: Item):
	if weapon_equipped:
		#todo: drop the other weapon, or put it in inventory with a way to switch?
		weapon.queue_free()
	weapon_equipped = true
	weapon = item.create_item_scene() as Weapon
	# calling back up - it feels more extension like, with signals we'd need to have
	# something implemented here too?  but maybe the handler could be a generic
	# 'execute' that the signaling objects sends up? then some player 
	# specific logic could happen before that happens if needed, like 'is dead' checks 
	weapon.init(self)
	hand.add_child.call_deferred(weapon)

func interact():
	var result = interaction_ray_cast.get_collider()
	if not result: return
	if result.is_in_group(Interfaces.Interactable):
		result.interact(self)

func _on_hunger_timer_timeout() -> void:
	if not hunger_enabled or is_dead(): return
	if nutrition <= 0:
		%HealthComponent.receive_damage(1)
	else:
		nutrition = nutrition - 1

func _on_health_depleted() -> void:
	state_machine.transition_to("DeadState")
	
func _on_rest_timer_timeout() -> void:
	rest_is_cooldown = false

func _on_dash_cooldown_timer_timeout() -> void:
	is_dash_cooldown = false
