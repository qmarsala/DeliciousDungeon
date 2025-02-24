class_name PlayerInventory
extends Resource

@export var weapons: Dictionary = {}
@export var items: Dictionary = {}

func has_weapon(weapon: Weapon2) -> bool:
	if weapon.data.weapon_type == Enums.WeaponTypes.None:
		return false
	return weapons.has(weapon.data.weapon_type)

func add_weapon(weapon: Weapon2) -> void:
	if weapon.data.weapon_type == Enums.WeaponTypes.None:
		return
	weapons[weapon.data.weapon_type] = weapon

func remove_weapon(weapon: Weapon2) -> void:
	if has_weapon(weapon):
		weapons.erase(weapon.data.weapon_typei)

func has_item(item: Item) -> bool:
	return has_item_by_id(item.data.item_id)

func has_item_by_id(item_id: Enums.Items) -> bool:
	if item_id == Enums.Items.None:
		return false
	return items.has(item_id) and items[item_id].count > 0
	
func has_enough_item(item: Item, count: int) -> bool:
	return has_enough_item_by_id(item.data.item_id, count)

func has_enough_item_by_id(item_id: Enums.Items, count: int) -> bool:
	if has_item_by_id(item_id):
		return items[item_id].count > count
	return false

func add_item(item: Item, count: int = 1) -> void:
	var key = item.data.item_id
	if key == Enums.Items.None or count < 1:
		return
	
	if has_item(item):
		items[key].count += count
	else:
		items[key] = ItemStack.new()
		items[key].item = item
		items[key].count = count
		
func remove_item(item: Item, count: int) -> ItemStack:
	var item_id = item.data.item_id
	return remove_item_by_id(item_id, count)

func remove_item_by_id(item_id: Enums.Items, count: int) -> ItemStack:
	if item_id == Enums.Items.None or count < 1:
		return

	var stack = _default_stack()
	if has_item_by_id(item_id):
		stack.data = items[item_id].data
		var actual_taken = min(count, items[item_id].count)
		stack.count = actual_taken
		items[item_id].count -= actual_taken
		if items[item_id].count < 1:
			items.erase(item_id)
	return stack
	
func _default_stack(name: String = "Junk") -> ItemStack:
	var stack = ItemStack.new()
	var data = ItemData.new()
	data.name = name
	stack.data = data
	stack.count = 0
	return stack
