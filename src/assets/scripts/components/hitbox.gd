class_name Hitbox
extends Area2D

@export var node: Node

func _ready() -> void:
	add_to_group(Interfaces.Damageable)

# should we just signal here?
func receive_damage(damage: float) -> void:
	if node.is_in_group(Interfaces.Damageable):
		node.receive_damage(damage)
