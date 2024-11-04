extends Node2D


func _on_rest_area_body_entered(body: Node2D) -> void:
	body.rest()
