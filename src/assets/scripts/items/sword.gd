class_name Sword
extends Weapon
#TODO: reevaluate the inheritance
# it is mostly to change animation/sprite stuff
# could maybe be handled by an animations component instead
 
@onready var animations: AnimatedSprite2D = $Animations

func handle_weapon_aim(attack_location: Vector2):
	if attack_location.x > global_position.x:
		animations.rotation_degrees = 80
	else:
		animations.rotation_degrees = -80

func handle_use_ability_animation(animation_name: String) -> void:
	animations.play(animation_name)
