class_name MovementComponent
extends Node

#todo: could this component also work with a 'get_movement_direction' contract
# to also handle that part of movement as well?

@export var character: CharacterBody2D
@export var character_sprite: AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if character.health_component and character.health_component.is_dead(): return
	play_movement_animation()
	character.move_and_slide()
	
func play_movement_animation():
	if character_sprite.is_playing() and (character_sprite.animation == "receive_damage" or character_sprite.animation == "dash"): return
	if character.velocity.length() == 0:
		character_sprite.play("idle")
	else:
		character_sprite.flip_h = character.velocity.x < 0
		character_sprite.play("run")
