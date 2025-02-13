class_name PlayerInventory
extends Resource

@export var items: Dictionary = {}

func add_item(item_data: ItemData2, count: int = 1) -> void:
	if item_data == null or item_data.name.is_empty() or count < 1:
		return
	
	var name = item_data.name.to_lower()
	if items.has(name):
		items[name].count += count
	else:
		items[name] = ItemStack.new()
		items[name].data = item_data
		items[name].count = count

func remove_item(item_name: String, count: int) -> ItemStack:
	var name = item_name.to_lower()
	var stack = _default_stack(name)
	if items.has(name) and items[name].count > 0:
		stack.data = items[name].data
		var actual_taken = min(count, items[name].count)
		stack.count = actual_taken
		items[name].count -= actual_taken
		if items[name].count < 1:
			items.erase(name)
	return stack

func _default_stack(name: String) -> ItemStack:
	var stack = ItemStack.new()
	var data = ItemData2.new()
	data.name = name
	stack.data = data
	stack.count = 0
	return stack
