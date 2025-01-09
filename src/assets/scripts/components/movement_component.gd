class_name MovementComponent
extends Node

#todo: could this component also work with a 'get_movement_direction' contract
# to also handle that part of movement as well?

@export var character: CharacterBody2D
#todo: can an animation tree take over here?
@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer

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
	if animation_player.is_playing() and (animation_player.current_animation == "receive_damage" or animation_player.current_animation == "dash"): return
	if character.velocity.length() == 0:
		animation_player.play("idle")
	else:
		var flip_sprite = character.velocity.x < 0
		var current_flip = sprite.flip_h
		sprite.flip_h = flip_sprite 
		if flip_sprite != current_flip:
			animation_player.advance(0)

		if animation_player.is_playing() and animation_player.current_animation == "run": return
		animation_player.play("run")

# this was an idea for stun before we realized that needs to do more than freeze you.
# could this be utilized for dash/engage/retreat though?
func set_speed_modifier(modifier: float, duration: float) -> void:
	speed_modifier_duration = duration
	speed_modifier = modifier
	speed_modifier_applied_at = time

func apply_speed_modifier():
	if time - speed_modifier_applied_at < speed_modifier_duration:
		character.velocity *= speed_modifier
	
