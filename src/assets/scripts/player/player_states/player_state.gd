extends Node
class_name PlayerState

@export var player: Player

signal Transitioned

var time = 0
func _process(delta: float) -> void:
	time += delta 

func enter():
	pass

func exit():
	pass

func handle_process(delta: float):
	pass

func _unhandled_input(event: InputEvent) -> void:
	handle_movement_input(event)
	handle_interact_action(event)

func handle_physics_process(delta: float):
	var was_holding = holding_move
	holding_move = move_pressed and time - pressed_at > .25
	if holding_move:
		player.move_destination_indicator.hide()
		player.move_target = player.get_global_mouse_position()
	if was_holding and !holding_move:
		player.move_destination_indicator.show()

func handle_interact_action(event: InputEvent) -> void:
	if not player: return
	if event.is_action_pressed("interact"):
		player.interact()

#in this method we have the details implemented here, in contrast to above where we call 'interact'
#just to play around with different approaches
#todo: how can we get the move indicator code consolidated into one spot?
var pressed_at = 0
var move_pressed = false
var holding_move = false
func handle_movement_input(event: InputEvent):
	if not player: return
	if player.move_disabled and event.is_action_released("move"):
		player.move_disabled = false
	
	if player.move_disabled: return
	var mouse_pos = player.get_global_mouse_position()
	if event.is_action_pressed("move"):
		pressed_at = time
		move_pressed = true
		player.move_target = mouse_pos
		player.move_destination_indicator.show()
		Transitioned.emit(self, "MoveState")
	elif event.is_action_released("move"):
		move_pressed = false
	elif event.is_action_pressed("dash") and not player.is_dash_cooldown:
		player.move_target = mouse_pos
		Transitioned.emit(self, "DashState")
