class_name Player2
extends CharacterBody2D

@onready var interact_range: Area2D = $InteractRange
@onready var campfire_placement_checker: Area2D = $CampfirePlacementChecker

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
	for a in interact_range.get_overlapping_areas():
		if a is InteractBox:
			a.interact(self)
			return

func pickup(item: Item, count: int = 1) -> void:
	data.inventory.add_item(item, count)

func setup_camp() -> void:
	if not (campfire_scene or campfire_placement_checker):
		printerr("missing campfire|placement checker scene")
		return 
	
	var cost = 2
	if data.inventory.has_enough_item_by_id(Enums.Items.Wood, cost) and campfire_placement_checker.get_overlapping_bodies().size() < 1:
		data.inventory.remove_item_by_id(Enums.Items.Wood, cost)
		var instance = campfire_scene.instantiate() as Node2D
		instance.global_position = global_position + Vector2.RIGHT * data.interaction_range
		get_tree().get_first_node_in_group("World").add_child(instance)

func light_fire(fire: Fire) -> void:
	var cost = 1
	if data.inventory.has_enough_item_by_id(Enums.Items.Wood, cost):
		data.inventory.remove_item_by_id(Enums.Items.Wood, cost)
		fire.light()

func cook() -> void:
	pass

func consume() -> void:
	pass
