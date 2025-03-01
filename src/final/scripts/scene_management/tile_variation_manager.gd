extends Node2D

func _ready() -> void:
	var tile_maps: Array[TileMapLayer]
	for c in get_children():
		if c is TileMapLayer:
			tile_maps.append(c as TileMapLayer)
	
	var total_count = tile_maps.size()
	var rng = randi_range(1,total_count)
	for tile_map in tile_maps:
		if not tile_map.name.begins_with(str(rng)):
			tile_map.queue_free()
