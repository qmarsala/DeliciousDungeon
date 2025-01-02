class_name Bow
extends Weapon

@onready var animations: AnimatedSprite2D = $Animations
@onready var attack_indicator: Sprite2D = $AttackIndicator

func handle_attack_indicator(attack_location: Vector2) -> void:
	super(attack_location)
	attack_indicator.rotation = deg_to_rad(90)

func handle_weapon_aim(attack_location: Vector2):
	look_at(attack_location)

func handle_use_ability_animation(animation_name: String) -> void:
	animations.play(animation_name)
