class_name RoomGenerator
extends Node2D

@export var initial_room: RoomData
@export var last_room: RoomData
@export var room_set: RoomDataSet 
@export var rest_room_set: RoomDataSet 
@export var total_room_count: int = 7

var random: RandomNumberGenerator = RandomNumberGenerator.new()
var finished: bool = false
var room_count: int = 0

func _ready() -> void:
	make_room(initial_room, global_position)

func _on_east_trigger(trigger_connector_position: Vector2, connect_to: String) -> void: 
	handle_trigger(trigger_connector_position, connect_to)
	
func _on_west_trigger(trigger_connector_position: Vector2,  connect_to: String) -> void: 
	handle_trigger(trigger_connector_position, connect_to)

func handle_trigger(connector_position: Vector2, connect_to: String):
	if finished: return
	if room_count >= total_room_count:
		finished = true
		make_room(last_room, connector_position, connect_to)
		return
	var rooms = room_set.rooms
	if room_count % 3 == 0 and rest_room_set.rooms.size() > 0:
		rooms = rest_room_set.rooms
	var room = rooms.pick_random()
	if room:
		make_room(room, connector_position, connect_to)

func make_room(room: RoomData, position: Vector2, connect_to: String = ""):
	room_count += 1
	var room_scene = room.scene.instantiate() as Room
	room_scene.connect_to = connect_to
	room_scene.global_position = position
	room_scene.EastTrigger.connect(_on_east_trigger)
	room_scene.WestTrigger.connect(_on_west_trigger)
	add_child.call_deferred(room_scene)
	return room_scene