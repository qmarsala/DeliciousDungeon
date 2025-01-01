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
	# feels like it could be in 'idle' state
	# and this is really what to do with the weapon when idle.
	# another thing an 'animation controller' could help with?
	# then maybe weapon data can include an animation controller
	# or dif implements of weapon ie staff/bow/sword can provide one
	# with a consistens interface for the states to call
	# or weapons could have their own state machine?
	#if player.velocity == Vector2.ZERO:
		#if use_sprite:
			#sprite.global_position = player.hand.global_position - Vector2(0, 3)
			#sprite.rotation_degrees = 0
		#else:
			#sprite.global_position = player.hand.global_position
			#animations.rotation_degrees = 30

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
# perhaps there could be an animatin controller with methods that
# our state machine could call into for things like 'idle'
func handle_weapon_aim(attack_location: Vector2):
	if aim_follows_cursor:
		look_at(attack_location)
	else: 
		if attack_location.x > global_position.x:
			if use_sprite:
				sprite.rotation_degrees = 60
			else:
				animations.rotation_degrees = 80
		else:
			if use_sprite:
				sprite.rotation_degrees = -60
			else:
				animations.rotation_degrees = -80
