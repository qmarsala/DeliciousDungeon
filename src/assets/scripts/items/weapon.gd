class_name Weapon
extends Node2D

var player: Player
# weapon data?
@export var max_range: float
@export var aim_follows_cursor: bool

# todo: animations - see move state in player
@onready var sprite = $Sprite2D
@onready var animations: AnimatedSprite2D = $Animations

func init(p: Player):
	player = p
	for a in $Abilities.get_children():
		if a is Ability:
			a.init(player, self)

func _process(delta: float) -> void:
	if player == null: return
	if not player.weapon_equipped:
		$AttackIndicator.hide()
	elif !$AttackIndicator.visible:
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
	if direction.length() > max_range:
		target_location = player.global_position + (direction.normalized() * max_range)
	return target_location
