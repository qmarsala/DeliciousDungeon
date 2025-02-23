class_name PlayerInventory
extends Resource

@export var weapons: Dictionary = {}
@export var items: Dictionary = {}

func has_weapon(weapon: Weapon2) -> bool:
	var key = _get_weapon_key(weapon)
	if key.is_empty():
		return false
	return weapons.has(key)

func add_weapon(weapon: Weapon2) -> void:
	var key = _get_weapon_key(weapon)
	if key.is_empty():
		return
	weapons[key] = weapon

func remove_weapon(weapon: Weapon2) -> void:
	var key = _get_weapon_key(weapon)
	if has_weapon(weapon):
		weapons.erase(key)

func has_item(item: Item) -> bool:
	var key = _get_item_key(item)
	if key.is_empty():
		return false
	return items.has(key)
	
func has_enough_item(item: Item, count: int) -> bool:
	if has_item(item):
		return items[_get_item_key(item)].count > count
	return false

func add_item(item: Item, count: int = 1) -> void:
	var key = _get_item_key(item)
	if key.is_empty() or count < 1:
		return
	
	if has_item(item):
		items[key].count += count
	else:
		items[key] = ItemStack.new()
		items[key].item = item
		items[key].count = count

func remove_item(item: Item, count: int) -> ItemStack:
	var key = _get_item_key(item)
	if key.is_empty() or count < 1:
		return

	var stack = _default_stack(item.data.name)
	if has_item(item):
		stack.data = items[key].data
		var actual_taken = min(count, items[key].count)
		stack.count = actual_taken
		items[key].count -= actual_taken
		if items[key].count < 1:
			items.erase(key)
	return stack

func _get_weapon_key(weapon: Weapon2) -> String:
	if weapon == null:
		return ""
	elif weapon.weapon_type == Enums.WeaponTypes.Melee:
		return "melee"
	else:
		return "ranged"

func _get_item_key(item: Item) -> String:
	if item == null:
		return ""
	else:
		return str(item.data.item_id)

func _default_stack(name: String) -> ItemStack:
	var stack = ItemStack.new()
	var data = ItemData.new()
	data.name = name
	stack.data = data
	stack.count = 0
	return stack
