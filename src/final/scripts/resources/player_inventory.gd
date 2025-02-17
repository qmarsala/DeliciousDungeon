class_name PlayerInventory
extends Resource

@export var weapons: Dictionary = {}

@export var items: Dictionary = {}

func has_weapon(weapon_data: WeaponData2) -> bool:
	var key = _get_weapon_key(weapon_data)
	if key.is_empty():
		return false
	return weapons.has(key)

func add_weapon(weapon_data: WeaponData2) -> void:
	var key = _get_weapon_key(weapon_data)
	if key.is_empty():
		return
	weapons[key] = weapon_data

func remove_weapon(weapon_data: WeaponData2) -> void:
	var key = _get_weapon_key(weapon_data)
	if has_weapon(weapon_data):
		weapons.erase(key)

func has_item(item_data: ItemData2) -> bool:
	var key = _get_item_key(item_data)
	if key.is_empty():
		return false
	return items.has(_get_item_key(item_data))

func add_item(item_data: ItemData2, count: int = 1) -> void:
	var key = _get_item_key(item_data)
	if key.is_empty() or count < 1:
		return
	
	if has_item(item_data):
		items[key].count += count
	else:
		items[key] = ItemStack.new()
		items[key].data = item_data
		items[key].count = count

func remove_item(item_data: ItemData2, count: int) -> ItemStack:
	var key = _get_item_key(item_data)
	if key.is_empty() or count < 1:
		return

	var stack = _default_stack(item_data.name)
	if has_item(item_data):
		stack.data = items[key].data
		var actual_taken = min(count, items[key].count)
		stack.count = actual_taken
		items[key].count -= actual_taken
		if items[key].count < 1:
			items.erase(key)
	return stack

func _get_weapon_key(weapon_data: WeaponData2) -> String:
	if weapon_data == null:
		return ""
	elif weapon_data.weapon_type == Enums.WeaponTypes.Melee:
		return "melee"
	else:
		return "ranged"

func _get_item_key(item_data: ItemData2) -> String:
	if item_data == null:
		return ""
	else:
		return item_data.name.to_lower()

func _default_stack(name: String) -> ItemStack:
	var stack = ItemStack.new()
	var data = ItemData2.new()
	data.name = name
	stack.data = data
	stack.count = 0
	return stack
