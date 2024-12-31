class_name Weapon
extends Node2D

var player: Player

# maybe this gets injected not exported?
# how can we not need to make a new scene if all we want to tweak is the data?
@export var weapon_data: WeaponData

@export var aim_follows_cursor: bool
@export var use_sprite: bool
@export var level_two_effect: PointLight2D

# todo: animations - see move state in player
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

# temp solution- problem: when we drop a weapon we want to make sure its up top 
# but when holding we want it to toggle behind us depending on direction
var sprite_z_rel = true

func init(p: Player, data: WeaponData = null):
	player = p
	use_data(data)
	sprite_z_rel = false

# todo: need to figure out how to be consistent with init vs ready
func _ready() -> void:
	if not use_sprite:
		sprite.hide()
		animations.show()
	sprite.z_as_relative = sprite_z_rel
	for ability_slot in ability_slots.get_child_count():
		if ability_slot < weapon_data.weapon_abilities.size():
			var ability = weapon_data.weapon_abilities[ability_slot]
			var slot = ability_slots.get_child(ability_slot) as Ability
			slot.init(player, self, ability)

func _process(delta: float) -> void:
	if player == null: return
	if not player.weapon_equipped:
		$AttackIndicator.hide()
	elif not $AttackIndicator.visible:
		$AttackIndicator.show()
	var location = get_attack_location()
	$AttackIndicator.global_position = location
	if aim_follows_cursor:
		$AttackIndicator.rotation_degrees = 90
		#this type of state makes me want scripts for the weapons indicators that can vary
		# maybe strategy pattern?
		look_at(location)
		var direction = location - player.hand.global_position
		var target_location = location
		if direction.length() > 4:
			target_location = player.hand.global_position + (direction.normalized() * 4)
			global_position = target_location

func get_attack_location() -> Vector2:
	var mouse_pos = player.get_global_mouse_position()
	var direction = mouse_pos - player.global_position
	var target_location = mouse_pos
	if direction.length() > weapon_data.max_range:
		target_location = player.global_position + (direction.normalized() * weapon_data.max_range)
	return target_location
