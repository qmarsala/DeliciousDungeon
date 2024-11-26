extends Node2D
class_name goblin_steak


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.pickup_food()
	queue_free()
