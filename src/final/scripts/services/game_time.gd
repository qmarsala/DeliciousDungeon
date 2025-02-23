class_name GameTimeService
extends Node

var world_node: Node2D

var is_paused: bool
var time: float = 0

func _process(delta: float) -> void:
	if is_paused: 
		return
	time += delta

func init(world: Node2D) -> void:
	world_node = world

func pause() -> void:
	is_paused = true
	if world_node:
		world_node.process_mode = Node.PROCESS_MODE_DISABLED

func play() -> void:
	is_paused = false
	if world_node:
		world_node.process_mode = Node.PROCESS_MODE_INHERIT
