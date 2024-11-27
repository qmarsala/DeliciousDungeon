extends Node2D
class_name pickup

@export var item: Item

func _ready():
	var scene = item.scene
	var instance = scene.instantiate()
	add_child(instance)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("pickup"):
		body.pickup(item)
		queue_free()
