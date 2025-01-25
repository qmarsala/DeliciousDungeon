class_name State
extends Node

var character: CharacterBody2D

signal Transitioned(State, String)

var time = 0
func _process(delta: float) -> void:
	time += delta 

func enter():
	pass

func exit():
	pass

func handle_process(delta: float):
	pass
	
func handle_physics_process(delta: float):
	pass
