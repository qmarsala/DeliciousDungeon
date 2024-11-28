class_name HealthComponent
extends Node

signal HealthDepleted

@export var character_sprite : AnimatedSprite2D
@export var starting_health : float = 5

var health : float = 1

func is_dead() -> bool : 
	return health <= 0

func _ready() -> void:
	health = starting_health

func take_damage(damage) -> void:
	if is_dead(): return
	
	health -= damage
	if character_sprite:
		character_sprite.stop()
		character_sprite.play("receive_damage")
	if is_dead():
		HealthDepleted.emit()
		if character_sprite:
			character_sprite.stop()
			character_sprite.play("die")

func heal(added_health) -> void:
	if is_dead(): return
	health = min(health + added_health, starting_health)
