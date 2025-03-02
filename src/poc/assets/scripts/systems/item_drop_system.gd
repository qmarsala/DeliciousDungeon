class_name ItemDropSystem
extends Node

var pickup_scene: PackedScene = preload("res://poc/scenes/items/pickup.tscn")

func drop_item(item: Item, target_position: Vector2):
	if pickup_scene:
		var drop_instance = pickup_scene.instantiate() as Pickup
		var xfac = randi_range(-1,1)
		if xfac == 0:
			xfac = 1
		var x = target_position.x + randf_range(5,7) * xfac
		var yfac = randi_range(-1,1)
		if yfac == 0:
			yfac = -1
		var y = target_position.y + randf_range(5,7) * yfac
		drop_instance.init(item, Vector2(x,y))
		var world = get_tree().get_first_node_in_group("World")
		if world:
			world.add_child.call_deferred(drop_instance)
		else:
			get_tree().root.add_child.call_deferred(drop_instance)

#todo:
func drop_item_stack(item_stack: ItemStack, target_position: Vector2):
	pass
