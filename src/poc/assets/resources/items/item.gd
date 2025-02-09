class_name Item
extends Resource

@export var data: ItemData
@export var scene: PackedScene

func create_item_scene() -> Node:
	var instance = scene.instantiate()
	if instance.has_method("use_data"):
		instance.use_data(data)
	return instance
