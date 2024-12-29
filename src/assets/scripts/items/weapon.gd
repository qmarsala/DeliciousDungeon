class_name Weapon
extends Node2D

var player: Player

# maybe this gets injected not exported?
# how can we not need to make a new scene if all we want to tweak is the data?
@export var weapon_data: WeaponData

@export var aim_follows_cursor: bool
@export var use_sprite: bool

# todo: animations - see move state in player
@onready var sprite = $Sprite2D
@onready var animations: AnimatedSprite2D = $Animations
@onready var ability_slots: Node = $AbilitySlots

func use_data(data: WeaponData):
	if data != null:
		weapon_data = data

# how could we hook up some ui for showing cooldowns?
func init(p: Player, data: WeaponData = null):
	player = p
	use_data(data)

# todo: need to figure out how to be consistent with init vs ready
func _ready() -> void:
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
		# I think this worked well on the skeleton because of the 'aim vector'
		look_at(location)
		# trying this in player instead
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
