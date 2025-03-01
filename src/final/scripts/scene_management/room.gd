class_name Room
extends Node2D

func init(room_size: int, neighbors: Array[Vector2]):
	for c in get_children():
		if c.name == "Covers":
			c.init(room_size, neighbors)
