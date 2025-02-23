class_name Player2
extends CharacterBody2D

@onready var interact_range: Area2D = $InteractRange

@export var campfire_scene: PackedScene

var data: PlayerData2

var player_aim_controler = PlayerAimController.new()
var player_move_controller = PlayerMovementController.new()
var player_actions_controller = PlayerActionsController.new()

func _ready() -> void:
	player_actions_controller.InteractPressed.connect(interact)
	player_actions_controller.SwitchWeaponsPressed.connect(switch_weapons)
	player_actions_controller.SetupCampPressed.connect(setup_camp)

func _process(delta: float) -> void:
	player_actions_controller.handle_input()

func _physics_process(delta: float) -> void:
	velocity = player_move_controller.get_velocity(velocity)
	move_and_slide()

func init(player_data: PlayerData2) -> void:
	if player_data == null:
		data = PlayerData2.new()
	else:
		data = player_data
	player_move_controller.init(data.speed)

func switch_weapons() -> void:
	print("switch weapons")

func interact() -> void:
	print("interact")
	for a in interact_range.get_overlapping_areas():
		if a is InteractBox:
			a.interact(self)
			return

func pickup(item: Item, count: int = 1) -> void:
	data.inventory.add_item(item, count)

func setup_camp() -> void:
	#var wood = Item.new()
	#wood.data.item_id = Enums.Items.Wood
	#if campfire_scene and data.inventory.has_item(wood):
		## todo: probably need to have a 'campfire placement system'
		## that allows us to 'aim' the placement, and check if its valid.
		#data.inventory.remove_item(wood, 1)
	var instance = campfire_scene.instantiate() as Node2D
	instance.global_position = global_position + (Vector2.RIGHT * data.interaction_range)
	get_tree().get_first_node_in_group("World").add_child(instance)

func cook() -> void:
	pass

func consume() -> void:
	pass
