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
	handle_interact_action()
	
func handle_physics_process(delta: float):
	handle_movement_input(delta)
	handle_dash_input()

# this is calling up... is this ok?
func handle_interact_action() -> void:
	if not player: return
	if Input.is_action_just_pressed("interact"):
		player.interact()

#in this method we have the details implemented here, in contrast to above where we call 'interact'
#just to play around with different approaches
var pressed_at = 0
func handle_movement_input(delta):
	if not player: return
	time += delta
	if player.move_disabled and Input.is_action_just_released("move"):
		player.move_disabled = false
	
	if player.move_disabled: return
	var mouse_pos = player.get_global_mouse_position()
	if Input.is_action_just_pressed("move"):
		pressed_at = time
		player.move_target = mouse_pos
		player.move_destination_indicator.show()
		Transitioned.emit(self, "MoveState")
	elif Input.is_action_pressed("move") and time - pressed_at > .1:
		player.move_target = mouse_pos
		player.move_destination_indicator.hide()
		Transitioned.emit(self, "MoveState")
	elif Input.is_action_just_released("move"):
#		feels like a bug waiting to happen here, if states switch during a move hold?
		player.move_destination_indicator.show()

func handle_dash_input():
	if not player: return
	var mouse_pos = player.get_global_mouse_position()
	if Input.is_action_just_pressed("dash") and not player.is_dash_cooldown:
		player.move_target = mouse_pos
		Transitioned.emit(self, "DashState")
