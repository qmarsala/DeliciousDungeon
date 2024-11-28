class_name RoomGenerator
extends Node2D

@export var initial_room: RoomData
@export var door_rooms: Array[RoomData]
@export var rooms: Array[RoomData]

var rooms_in_a_row: int = 0

var random: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	make_room(global_position, initial_room)

func _on_basic_room_east_trigger(new_room_position, trigger_room_type: String) -> void: 
	if trigger_room_type.to_lower() != "door":
		rooms_in_a_row += 1
	if rooms_in_a_row >= 4:
		make_room(new_room_position, door_rooms.pick_random())
		rooms_in_a_row = 0
		return

	if trigger_room_type.to_lower() == "door":
		make_room(new_room_position, rooms.pick_random())
	else:
		if randf() <= .65:
			make_room(new_room_position, rooms.pick_random())
		else:
			make_room(new_room_position, door_rooms.pick_random())

func make_room(position, next_room):
	var next_room_instance = next_room.scene.instantiate() as Room
	next_room_instance.global_position = position
	next_room_instance.EastTrigger.connect(_on_basic_room_east_trigger)
	add_child.call_deferred(next_room_instance)
