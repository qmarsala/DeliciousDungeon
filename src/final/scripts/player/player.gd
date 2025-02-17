class_name Player2
extends CharacterBody2D

var data: PlayerData2

var player_move_controller = PlayerMovementController.new()

func _physics_process(delta: float) -> void:
	velocity = player_move_controller.get_velocity(velocity)
	move_and_slide()

func init(player_data: PlayerData2) -> void:
	data = player_data

func attack() -> void:
	pass
	
func equip() -> void:
	pass
	
func unequip() -> void:
	pass

func switch_weapons() -> void:
	pass

func pickup() -> void:
	pass

func drop() -> void:
	pass

func cook() -> void:
	pass

func consume() -> void:
	pass

func save() -> void:
	pass
