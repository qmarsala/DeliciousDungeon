class_name RoomGenerator
extends Node2D

@export var next_room: PackedScene

@onready var area_2d: Area2D = $Area2D
@onready var east_connector: Node2D = $EastConnector


func _on_area_2d_body_entered(body: Node2D) -> void:
	area_2d.queue_free()
	var room = next_room.instantiate()
	room.next_room = next_room
	east_connector.add_child(room)
	
