class_name AbilitySlot
extends Node

signal ability_bound(int)
signal ability_unbound(int)
signal ability_pressed(int)
signal ability_released(int)

#todo: could get this from settings to allow key bind changes?
@export var input_event: String = "ability_one"

var is_bound: bool: 
	get: return ability_id > 99
var ability_id: int

func bind_ability(ability_id: int):
	if is_bound: return
	is_bound = true
	self.ability_id = ability_id
	ability_bound.emit(self.ability_id)

func unbind_ability():
	is_bound = false
	ability_unbound.emit(self.ability_id)
	self.ability_id = -1

func _unhandled_input(event: InputEvent) -> void:
	if not is_bound: return
	if event.is_action_pressed(input_event):
		ability_pressed.emit(ability_id)
	if event.is_action_released(input_event):
		ability_released.emit(ability_id)
