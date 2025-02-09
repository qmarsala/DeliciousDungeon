class_name Staff
extends Weapon

@export var level_two_effect: PointLight2D

@onready var sprite = $Sprite2D

func use_data(data: WeaponData) -> void:
	super(data)
	if data.weapon_level > 1:
		level_two_effect.show()

func handle_weapon_aim(attack_location: Vector2):
	if attack_location.x > global_position.x:
		sprite.rotation_degrees = 60
	else:
		sprite.rotation_degrees = -60
