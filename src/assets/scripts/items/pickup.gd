extends Node2D
class_name Pickup

@export var item: Item

var delay: float = .5
var time: float = 0 #should we have a master time service?

func _ready():
	var instance = item.create_item_scene()
	add_child(instance)

func _process(delta: float) -> void:
	time += delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if time < delay: return
	if body.has_method("pickup"):
		body.pickup(item)
		queue_free()
