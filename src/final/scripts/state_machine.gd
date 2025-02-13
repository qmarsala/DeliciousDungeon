class_name StateMachine2
extends Node

@export var initial_state: State2

var current_state: State2
var states: Dictionary = {}
var character: CharacterBody2D

func init(c: CharacterBody2D):
	character = c
	for child in get_children():
		if child is State2:
			states[child.name.to_lower()] = child
			child.character = c
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.handle_process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.handle_physics_process(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	transition_to(new_state_name)

func transition_to(new_state_name):
	var new_state = states.get(new_state_name.to_lower())
	if !new_state or new_state == current_state:
		return
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state
