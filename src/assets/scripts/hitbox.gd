class_name Hitbox
extends Area2D

@export var character: CharacterBody2D

func _ready() -> void:
	add_to_group(Interfaces.Damageable)

func receive_damage(damage: float) -> void:
	if character:
		character.receive_damage(damage)
