class_name MovementComponent
extends Node

#todo: could this component also work with a 'get_movement_direction' contract
# to also handle that part of movement as well?

@export var character: CharacterBody2D
@export var character_sprite: AnimatedSprite2D

# todo: not sure this is the best place for this? but how else/where else would it go?
# we want to modify movement speed and this controls final movement
var speed_modifier: float = 1
var speed_modifier_duration: float = 0
var speed_modifier_applied_at: float = 0


var time = 0
func _process(delta: float) -> void:
	time += 0

func _physics_process(delta: float) -> void:
	if character.health_component and character.health_component.is_dead(): return
	apply_speed_modifier()
	play_movement_animation()
	character.move_and_slide()
	
func play_movement_animation():
	if character_sprite.is_playing() and (character_sprite.animation == "receive_damage" or character_sprite.animation == "dash"): return
	if character.velocity.length() == 0:
		character_sprite.play("idle")
	else:
		character_sprite.flip_h = character.velocity.x < 0
		character_sprite.play("run")

# this was an idea for stun before we realized that needs to do more than freeze you.
# could this be utilized for dash/engage/retreat though?
func set_speed_modifier(modifier: float, duration: float) -> void:
	speed_modifier_duration = duration
	speed_modifier = modifier
	speed_modifier_applied_at = time

func apply_speed_modifier():
	if time - speed_modifier_applied_at < speed_modifier_duration:
		character.velocity *= speed_modifier
	
