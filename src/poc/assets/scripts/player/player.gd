class_name Player
extends CharacterBody2D

signal player_died
signal equipped_weapon
signal unequipped_weapon

@export var player_data: PlayerData

@export var hunger_enabled: bool = true

@onready var state_machine: StateMachine = $StateMachine
@onready var interaction_ray_cast: RayCast2D = $InteractionRayCast
@onready var character_sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var destination_marker: DestinationMarker = $DestinationMarker
@onready var player_rest_sound: AudioStreamPlayer2D = $PlayerRestSound
@onready var health_component: HealthComponent = %HealthComponent
@onready var status_effects_component: StatusEffectComponent = $StatusEffectsComponent
@onready var hitbox: Hitbox = $Hitbox
@onready var ability_slots: AbilitySlots = $AbilitySlots

#todo: component
@onready var rest_timer: Timer = $RestTimer

#todo: component
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer

@onready var hand: Node2D = $Hand

var rest_is_cooldown = false
var move_target: Vector2
var move_disabled: bool
var is_dashing: bool
var is_dash_cooldown: bool
var is_hill: bool
var weapon: Weapon
var weapon_equipped: bool

func _ready() -> void:
	player_data.reset_nutrition()
	player_data.reset_health()
	state_machine.init(self)
	status_effects_component.init(health_component, state_machine)
	health_component.HealthDepleted.connect(_on_health_depleted)
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timer_timeout)
	hitbox.connect_weapon_events(equipped_weapon, unequipped_weapon)
	move_target = global_position
	if player_data.equipped_weapon and not weapon:
		var weapon_item = player_data.equipped_weapon
		equip(weapon_item)
	if Input.is_action_pressed("move"):
		move_disabled = true

func _process(delta: float) -> void:
	interaction_ray_cast.look_at(get_global_mouse_position())
	#todo: move this to ui layer?
	if global_position.distance_to(move_target) <= 5:
		destination_marker.hide()

func begin_rest() -> void:
	if player_data.items[Enums.Items.Food] < 1 or rest_is_cooldown: return
	state_machine.transition_to("Rest")

# should this live in the resting state? or just be called from there?
func complete_rest() -> void:
	SignalBus.ActionPerformed.emit(Enums.Actions.Rest)
	player_data.items[Enums.Items.Food] -= 1
	rest_is_cooldown = true
	rest_timer.start(30)
	player_data.reset_nutrition()
	health_component.heal(health_component.starting_health * .35) # todo: should come from food
	player_rest_sound.play()

func pickup(item: Item) -> void:
	print("picked up: " + item.data.name)
	if item.data is WeaponData:
		equip(item)
	elif item.data is PotionData:
		drink(item)
	else:
		player_data.items[item.data.item_id] += 1

func switch_weapons() -> void:
	var temp = player_data.backpack_weapon
	player_data.equipped_weapon = player_data.backpack_weapon
	player_data.backpack_weapon = temp

func equip(item: Item) -> void:
	if not player_data.backpack_weapon and player_data.equipped_weapon:
		player_data.backpack_weapon = player_data.equipped_weapon
		player_data.equipped_weapon = null
		weapon_equipped = false
	if weapon_equipped:
		unequip()
	weapon_equipped = true
	player_data.equipped_weapon = item
	weapon = player_data.equipped_weapon.create_item_scene() as Weapon
	weapon.equip(self)
	equipped_weapon.emit(weapon)

func unequip() -> void:
	weapon.unequip()
	weapon_equipped = false
	ItemDropper.drop_item(player_data.equipped_weapon, global_position)
	player_data.equipped_weapon = null # todo: not null, but default 'fist' weapon?
	unequipped_weapon.emit()

func drink(item: Item):
	var potion = item.data as PotionData
	if potion.healing > 0:
		health_component.heal(potion.healing)
	if potion.nutrition > 0:
		player_data.nutrition += potion.nutrition

func interact() -> void:
	var result = interaction_ray_cast.get_collider()
	if result is InteractBox:
		result.interact(self)

func get_armour_value() -> float:
	if weapon_equipped:
		return player_data.weapon.data.armour
	else:
		return 0

func get_evasion_value() -> float:
	if weapon_equipped:
		return player_data.weapon.data.evasion
	else:
		return 0

func increase_max_health(amount: float, duration: float):
	pass

func increase_min_damage(amount: float, duration: float):
	pass

func _on_hunger_timer_timeout() -> void:
	if not hunger_enabled or health_component.is_dead(): return
	if player_data.nutrition <= 0:
		health_component.receive_damage(1)
	else:
		player_data.nutrition -= 1

func _on_health_depleted() -> void:
	state_machine.transition_to("Dead")
	
func _on_rest_timer_timeout() -> void:
	rest_is_cooldown = false

func _on_dash_cooldown_timer_timeout() -> void:
	is_dash_cooldown = false
