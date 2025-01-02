class_name Sword
extends Weapon

@onready var animations: AnimatedSprite2D = $Animations

func handle_weapon_aim(attack_location: Vector2):
	if attack_location.x > global_position.x:
		animations.rotation_degrees = 80
	else:
		animations.rotation_degrees = -80
