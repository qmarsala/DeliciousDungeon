class_name Chest
extends Node2D

@export var spawn_rate: float = 1
@export var is_locked: bool = false
@export var drop_table: ItemDropTable

@onready var reward_location: Node2D = $RewardLocation
@onready var interactbox: InteractBox = $Interactbox

var is_open = false

func _ready() -> void:
	var drop_table_override = find_child("DropTable")
	if drop_table_override:
		drop_table = drop_table_override.get_drop_table()
	if randf() > spawn_rate:
		queue_free()
		return
	add_to_group(Interfaces.Interactable)
	interactbox.interacted.connect(interact)

func interact(player: Player):
	if is_locked or is_open:
		return # todo check for key
	is_open = true
	$InteractIndicator.disable_indicator()
	$Open.show()
	$Closed.hide()
	var reward = drop_table.get_drop_result()
	for r in reward.quantity:
		var pos = Vector2(reward_location.global_position.x + randf_range(-1, 1), reward_location.global_position.y + randf_range(-1, 1))
		ItemDropper.drop_item(reward.item, pos)
