extends Node2D

var character: Player
var weapon: Weapon
@export var reach: float = 8

func _ready() -> void:
	# I feel this is safe to assume hands.
	character = get_parent() as Player
	character.equipped_weapon.connect(on_weapon_equip)
	character.unequipped_weapon.connect(on_weapon_unequip)
	z_as_relative = false

func _process(delta: float) -> void:
	if not is_instance_valid(character): return
	var direction = character.get_global_mouse_position() - character.global_position
	if direction.length() > reach:
		position = (direction.normalized() * reach) + Vector2(0,3)
	else:
		position = direction + Vector2(0, 3)
	if position.y < 1:
		z_index = character.z_index - 1
	else:
		z_index = character.z_index

func on_weapon_equip(weapon: Weapon):
	self.weapon = weapon
	add_child.call_deferred(weapon)

func on_weapon_unequip():
	if weapon:
		weapon.queue_free.call_deferred()
