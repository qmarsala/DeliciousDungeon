class_name Weapon
extends Node2D

var player: Player
@export var max_range: float

# todo: animations - see move state in player
@onready var sprite = $Sprite2D

func init(p: Player):
	player = p
	for a in $Abilities.get_children():
		if a is MagicAttack: #todo: ability contract
			a.init(player, self)

func _process(delta: float) -> void:
	if player == null: return
	if not player.weapon_equipped:
		$AttackIndicator.hide()
	elif !$AttackIndicator.visible:
		$AttackIndicator.show()
	$AttackIndicator.global_position = get_attack_location()

func get_attack_location() -> Vector2:
	var mouse_pos = player.get_global_mouse_position()
	var direction = mouse_pos - player.global_position
	var target_location = mouse_pos
	if direction.length() > max_range:
		target_location = player.global_position + (direction.normalized() * max_range)
	return target_location
