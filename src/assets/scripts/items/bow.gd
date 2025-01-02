class_name Bow
extends Weapon

@onready var animations: AnimatedSprite2D = $Animations

func handle_attack_indicator(attack_location: Vector2) -> void:
	super(attack_location)
	$AttackIndicator.rotation_degrees = 90

func handle_weapon_aim(attack_location: Vector2):
	look_at(attack_location)
