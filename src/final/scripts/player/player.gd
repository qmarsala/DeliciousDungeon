class_name Player2
extends CharacterBody2D

var data: PlayerData2

var player_aim_controler = PlayerAimController.new()
var player_move_controller = PlayerMovementController.new()
var player_actions_controller = PlayerActionsController.new()

func _ready() -> void:
	player_actions_controller.InteractPressed.connect(interact)
	player_actions_controller.SwitchWeaponsPressed.connect(switch_weapons)

func _process(delta: float) -> void:
	player_actions_controller.handle_input()

func _physics_process(delta: float) -> void:
	velocity = player_move_controller.get_velocity(velocity)
	move_and_slide()

func init(player_data: PlayerData2) -> void:
	data = player_data

func switch_weapons() -> void:
	print("switch weapons")

func interact() -> void:
	print("interact")

func pickup() -> void:
	pass

func cook() -> void:
	pass

func consume() -> void:
	pass
