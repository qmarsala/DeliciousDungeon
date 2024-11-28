class_name Room
extends Node2D

signal EastTrigger

@export var room_type: String

@onready var east_trigger: Area2D = $EastTrigger
@onready var east_connector: Node2D = $EastConnector

func _on_area_2d_body_entered(body: Node2D) -> void:
	east_trigger.queue_free()
	EastTrigger.emit(east_connector.global_position, room_type)
