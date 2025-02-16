class_name MovementComponent
extends Node

#todo: could this component also work with a 'get_movement_direction' contract
# to also handle that part of movement as well?

@export var character: CharacterBody2D
#todo: can an animation tree take over here?
@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer

func _physics_process(delta: float) -> void:
	if character.health_component and character.health_component.is_dead(): return
	play_movement_animation()
	character.move_and_slide()
	
func play_movement_animation():
	if animation_player.is_playing() and animation_player.current_animation == "dash": return
	if character.velocity.length() == 0:
		if animation_player.is_playing() and animation_player.current_animation != "run": return
		animation_player.play("idle")
	else:
		var flip_sprite = character.velocity.x < 0
		var current_flip = sprite.flip_h
		sprite.flip_h = flip_sprite 
		if flip_sprite != current_flip:
			animation_player.advance(0)
			
		animation_player.play("run")
