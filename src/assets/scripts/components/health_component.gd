class_name HealthComponent
extends Node

signal HealthDepleted

#todo:wrap in animation controller?
@export var character_sprite : AnimatedSprite2D
@export var animation_player : AnimationPlayer

# still unsure how I feel about this, maybe it make sense
# that as a component of the character we have access to the character?
@export var character: CharacterBody2D
@export var starting_health : float = 5

var health : float = 1

func is_dead() -> bool : 
	return health <= 0

func _ready() -> void:
	health = starting_health

func take_damage(damage) -> void:
	if is_dead(): return
	if character:
		SignalBusService.DamageReceived.emit(damage, character.global_position)

	health -= damage
	if character_sprite and !(character_sprite.is_playing() and character_sprite.animation == "dash"):
		character_sprite.stop()
		character_sprite.play("receive_damage")
	if animation_player and animation_player.has_animation("receive_damage"):
		animation_player.play("receive_damage")
	if is_dead():
		HealthDepleted.emit()
		if character_sprite:
			character_sprite.stop()
			character_sprite.play("die")

func heal(added_health) -> void:
	if is_dead(): return
	health = min(health + added_health, starting_health)
