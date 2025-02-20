class_name Item
extends Resource

@export var data: ItemData = ItemData.new()
@export var scene: PackedScene

func create_item_scene() -> Node:
	if not scene:
		return Node2D.new()
	
	var instance = scene.instantiate()
	if instance.has_method("init_data"):
		instance.init_data(data)
	return instance
