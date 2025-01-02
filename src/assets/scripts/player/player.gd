class_name Player
extends CharacterBody2D

signal PlayerDied
signal EquippedWeapon(weapon: Weapon)

const SPEED = 60.0
const DASH_MULTIPLIER = 1.8
const DASH_TIME = .4
const DASH_COOLDOWN = 1
const INTERACTION_RANGE = 15.0
const STARTING_NUTRITION = 10

@export var hunger_enabled: bool = true

@onready var state_machine: StateMachine = $StateMachine
@onready var interaction_ray_cast: RayCast2D = $InteractionRayCast
@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var move_destination_indicator: Sprite2D = $MoveIndicator
@onready var player_rest_sound: AudioStreamPlayer2D = $PlayerRestSound
@onready var health_component: HealthComponent = %HealthComponent
@onready var status_effects_component: StatusEffectComponent = $StatusEffectsComponent
@onready var hitbox: Hitbox = $Hitbox

#todo: component
@onready var rest_timer: Timer = $RestTimer

#todo: component
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer

@onready var hand: Node2D = $Hand

var rest_is_cooldown = false
#todo: inventory
#this comes from 'game' don't like it, but poc'ing having player data outside of player
var player_items: Dictionary = {0:1,1:1}
var nutrition: float

var move_target: Vector2
var move_disabled: bool
var is_dashing: bool
var is_dash_cooldown: bool

#how else could we do this?
# if hills go east west we may also want to pitch the angle of movement
var is_hill: bool

#temp:
var weapon_item: Item
var weapon: Weapon
var weapon_equipped: bool

func _ready() -> void:
	state_machine.init(self)
	health_component.HealthDepleted.connect(_on_health_depleted)
	status_effects_component.init(health_component, state_machine)
	nutrition = STARTING_NUTRITION
	move_target = global_position
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timer_timeout)
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
	nutrition = min(STARTING_NUTRITION, nutrition + STARTING_NUTRITION * .65)
	health_component.heal(health_component.starting_health * .35) # todo: should come from food
	SignalBusService.ActionPerformed.emit(Enums.Actions.Rest)
	player_rest_sound.play()

func pickup(item: Item):
	print("picked up: " + item.data.name)
	if item.data is WeaponData:
		equip(item)
	else:
		player_items[item.data.item_id] += 1

func equip(item: Item):
	if weapon_equipped:
		weapon.queue_free()
		ItemDropService.drop_item(weapon_item, global_position)
	weapon_equipped = true
	weapon_item = item
	weapon = weapon_item.create_item_scene() as Weapon
	# currently sending the whole scene to be able to track ability cooldowns
	# there is probably a better way to do this?
	EquippedWeapon.emit(weapon)
	# calling back up - it feels more extension like, with signals we'd need to have
	# something implemented here too?  but maybe the handler could be a generic
	# 'execute' that the signaling objects sends up? then some player 
	# specific logic could happen before that happens if needed, like 'is dead' checks 
	weapon.equip(self)
	hand.add_child.call_deferred(weapon)

func interact():
	var result = interaction_ray_cast.get_collider()
	if result is InteractBox:
		result.interact(self)

func _on_hunger_timer_timeout() -> void:
	if not hunger_enabled or health_component.is_dead(): return
	if nutrition <= 0:
		health_component.receive_damage(1)
	else:
		nutrition -= 1

func _on_health_depleted() -> void:
	state_machine.transition_to("Dead")
	
func _on_rest_timer_timeout() -> void:
	rest_is_cooldown = false

func _on_dash_cooldown_timer_timeout() -> void:
	is_dash_cooldown = false
