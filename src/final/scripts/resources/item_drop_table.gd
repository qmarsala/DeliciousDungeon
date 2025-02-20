extends Resource
class_name ItemDropTable

@export var items: Array[ItemDropChance] = []

func get_drop_result() -> ItemStack:
	var roll = randf()
	var item_candidates = items.filter(func (x: ItemDropChance): return roll >= 1 - x.chance)
	var result = ItemStack.new()
	if item_candidates.size() < 1:
		return result
	
	var item_drop = item_candidates.pick_random() as ItemDropChance
	result.item = item_drop.item
	if item_drop.min_quantity == item_drop.max_quantity:
		result.count = item_drop.max_quantity
	else:
		result.count = randi_range(item_drop.min_quantity, item_drop.max_quantity)
	return result
