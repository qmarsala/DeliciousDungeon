class_name Room
extends Node2D

signal EastTrigger
signal WestTrigger

#todo: how to handle start/end rooms
@export var is_starting_room: bool
@export var is_ending_room: bool
@export var end_trigger: Area2D

var east_trigger: Area2D
var west_trigger: Area2D
var east_connector: Node2D
var west_connector: Node2D
#todo: north south?
#todo: rooms that don't have another connector, or not all of the connectors

var connect_to: String = ""

func _ready():
	#temp start/end room handling: forces west -> east
	# but next version should be more dynamic
	if is_starting_room:
		east_connector = $EastConnector
		WestTrigger.emit(east_connector.global_position, "east")
		return
	if is_ending_room:
		west_connector = $WestConnector
		var correction = global_position - west_connector.global_position
		global_position += correction
		return

	east_trigger = $EastTrigger
	west_trigger = $WestTrigger
	east_connector = $EastConnector
	west_connector = $WestConnector
	if connect_to.to_lower() == "east":
		var correction = global_position - west_connector.global_position
		global_position += correction
		east_trigger.queue_free()
		west_trigger.body_entered.connect(_on_west_trigger_body_entered)
	elif connect_to.to_lower() == "west":
		var correction = global_position - east_connector.global_position
		global_position += correction
		west_trigger.queue_free()
		east_trigger.body_entered.connect(_on_east_trigger_body_entered)
	else:
		west_trigger.body_entered.connect(_on_west_trigger_body_entered)
		east_trigger.body_entered.connect(_on_east_trigger_body_entered)

func _on_east_trigger_body_entered(body: Node2D) -> void:
	east_trigger.queue_free()
	EastTrigger.emit(west_connector.global_position, "west")

func _on_west_trigger_body_entered(body: Node2D) -> void:
	west_trigger.queue_free()
	WestTrigger.emit(east_connector.global_position, "east")
