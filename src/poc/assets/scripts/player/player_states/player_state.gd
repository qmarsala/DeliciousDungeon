extends State
class_name PlayerState

var player: Player:
	get: return character as Player

func _unhandled_input(event: InputEvent) -> void:
	handle_movement_input(event)
	handle_interact_action(event)

# should these things be moved to a 'movement constroller'
# states that need this disabled could then set the controller to be 
# enabled/disabled on state changes?
func handle_physics_process(delta: float):
	var was_holding = holding_move
	holding_move = move_pressed and time - pressed_at > .25
	if holding_move:
		player.destination_marker.hide()
		player.move_target = player.get_global_mouse_position()
		Transitioned.emit(self, "Move")
	if was_holding and !holding_move:
		player.move_target = player.get_global_mouse_position()
		player.destination_marker.show_at(player.move_target)

func handle_interact_action(event: InputEvent) -> void:
	if not player: return
	if event.is_action_pressed("interact"):
		player.interact()
		get_viewport().set_input_as_handled()

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
		player.destination_marker.show_at(player.move_target)
		Transitioned.emit(self, "Move")
	elif event.is_action_released("move"):
		move_pressed = false
	elif event.is_action_pressed("dash") and not player.is_dash_cooldown:
		player.move_target = mouse_pos
		player.destination_marker.show_at(player.move_target)
		Transitioned.emit(self, "Dash")
