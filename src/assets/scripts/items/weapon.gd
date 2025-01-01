class_name Weapon
extends Node2D

var player: Player

@export var weapon_data: WeaponData

#todo: need some sort of animations controller
# so each weapon can control its animations if needed
# ie, bow is static, but staff tilts
@export var aim_follows_cursor: bool
@export var level_two_effect: PointLight2D
@export var use_sprite: bool
@onready var sprite = $Sprite2D
@onready var animations: AnimatedSprite2D = $Animations
@onready var ability_slots: Node = $AbilitySlots

func use_data(data: WeaponData):
	if data != null:
		weapon_data = data
		#temp experiment, how can we cut down on useless extra scenes
		if weapon_data.weapon_level > 1:
			scale = Vector2.ONE * .8
			if level_two_effect:
				level_two_effect.show()

func init(p: Player, data: WeaponData = null):
	player = p
	use_data(data)
	#z_as_relative = false

func _ready() -> void:
	if not use_sprite:
		sprite.hide()
		animations.show()
	for ability_slot in ability_slots.get_child_count():
		if ability_slot < weapon_data.weapon_abilities.size():
			var ability = weapon_data.weapon_abilities[ability_slot]
			var slot = ability_slots.get_child(ability_slot) as Ability
			slot.init(player, self, ability)

func _process(delta: float) -> void:
	if not is_instance_valid(player): return
	var location = get_attack_location()
	handle_attack_indicator(location)
	handle_weapon_aim(location)

func get_attack_location() -> Vector2:
	var mouse_pos = player.get_global_mouse_position()
	var direction = mouse_pos - player.global_position
	var target_location = mouse_pos
	if direction.length() > weapon_data.max_range:
		target_location = player.global_position + (direction.normalized() * weapon_data.max_range)
	return target_location

func handle_attack_indicator(attack_location: Vector2) -> void:
	if not player.weapon_equipped:
		$AttackIndicator.hide()
	elif not $AttackIndicator.visible:
		$AttackIndicator.show()
	$AttackIndicator.global_position = attack_location
	if aim_follows_cursor:
		$AttackIndicator.rotation_degrees = 90

# this an the following method probably need to live somewhere else
# or use better params from the weapon we are representing.
func handle_weapon_aim(attack_location: Vector2):
	if aim_follows_cursor:
		look_at(attack_location)
	elif use_sprite:
		if attack_location.x > global_position.x:
			sprite.rotation_degrees = 75
		else:
			sprite.rotation_degrees = -75

# this used to be controlled by states, maybe it could be? but the method to do it
# should be implemented by the weapon
func handle_weapon_animation():
	pass
	#if use_sprite:
		#player.weapon.sprite.rotation_degrees = -75
	#else:
		#player.weapon.sprite.rotation_degrees = 75
