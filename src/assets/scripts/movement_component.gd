class_name MovementComponent
extends Node

@export var character: CharacterBody2D
@export var character_sprite: AnimatedSprite2D

var noise: int = 10

func _physics_process(delta: float) -> void:
	if character.has_method("is_dead") and character.is_dead(): return
	play_movement_animation()
	character.move_and_slide()
	
func play_movement_animation():
	if character_sprite.is_playing() and character_sprite.animation == "receive_damage": return
	if character.velocity.length() == 0:
		character_sprite.play("idle")
	else:
		character_sprite.flip_h = character.velocity.x < 0
		if character.velocity.length() > (character.SPEED + noise):
			character_sprite.play("dash")
		else:
			character_sprite.play("run")
