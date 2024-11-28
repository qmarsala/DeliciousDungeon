extends TileMapLayer
class_name Door

@export var door_pos = Vector2(-4,-6)
@export var open_door_pos = Vector2(7,2)
@export var door_width = 3
@export var door_height = 2

# todo: wonder if this could be done with an animated sprite and the sprite sheet.
# which we will want for other styles of doors. this only works for the double door sprite
func open():
	var i = 0
	var j = 0
	while i < door_width:
		set_cell(Vector2(door_pos.x + i, door_pos.y), 2, Vector2(open_door_pos.x + i, open_door_pos.y))
		i = i + 1
		while j < door_height:
			set_cell(Vector2(door_pos.x + i, door_pos.y + j), 2, Vector2(open_door_pos.x + i, open_door_pos.y + j))
			j = j + 1
