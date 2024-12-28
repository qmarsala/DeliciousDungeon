extends Node2D
class_name Pickup

@export var item: Item

# todo: this node really should just encompas the area and the call to pickup
# and not be to concerned about the item.  but if we ever wanted to have 
# mouse over to see detail of a weapon pickup, that data would not yet be there
# currently...
func _ready():
	var scene = item.scene
	var instance = scene.instantiate()
	add_child(instance)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("pickup"):
		body.pickup(item)
		queue_free()
