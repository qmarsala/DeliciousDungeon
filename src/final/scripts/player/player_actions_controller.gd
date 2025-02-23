class_name PlayerActionsController
extends RefCounted

signal AbilityOnePressed
signal AbilityTwoPressed
signal DashPressed
signal InteractPressed
signal SwitchWeaponsPressed
signal SetupCampPressed

func handle_input() -> void:
	if Input.is_action_just_pressed("ability_one"):
		AbilityOnePressed.emit()
	if Input.is_action_just_pressed("ability_two"):
		AbilityTwoPressed.emit()
	if Input.is_action_just_pressed("dash"):
		DashPressed.emit()
	if Input.is_action_just_pressed("interact"):
		InteractPressed.emit()
	if Input.is_action_just_pressed("switch_weapons"):
		SwitchWeaponsPressed.emit()
	if Input.is_action_just_pressed("setup_camp"):
		SetupCampPressed.emit()
	
