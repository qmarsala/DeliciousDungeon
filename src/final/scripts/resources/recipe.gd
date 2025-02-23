class_name Recipe
extends Resource

@export var ingredients: Array[ItemStack] = []
@export var result: Item = Item.new()
@export var difficulty: int = 0
@export var sprite: AtlasTexture
@export var name: String = "A recipe for nothing"
@export var description: String = "I wouldn't bother cooking it"

func make(inventory: PlayerInventory) -> Item:
	var success = randi_range(1,100) > difficulty
	if ingredients.all(func (i): return inventory.has_enough_item(i.item, i.count)):
		for i in ingredients:
			inventory.remove_item(i.item, i.count)
		if success:
			return result
		else:
			return Item.new()
	else:
		return Item.new()
