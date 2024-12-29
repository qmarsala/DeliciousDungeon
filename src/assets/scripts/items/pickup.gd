extends Node2D
class_name Pickup

@export var item: Item

func _ready():
	var instance = item.create_item_scene()
	add_child(instance)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("pickup"):
		body.pickup(item)
		queue_free()
