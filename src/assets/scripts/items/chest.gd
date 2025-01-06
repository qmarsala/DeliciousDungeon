class_name Chest
extends Node2D

@export var spawn_rate: float = 1
@export var is_locked: bool = false

# we should have an item database
# and drop tables as resources? so we only have one place to go to 
# add new items to the game
# then we can configure things that drop with a table?
@export var items: Array[Item]

@onready var reward_location: Node2D = $RewardLocation
@onready var interactbox: InteractBox = $Interactbox

var is_open = false

func _ready() -> void:
	if randf() > spawn_rate:
		queue_free()
		return
	add_to_group(Interfaces.Interactable)
	interactbox.interacted.connect(interact)

func interact(player: Player):
	if is_locked or is_open:
		return # todo check for key
	is_open = true
	$Open.show()
	$Closed.hide()
	var reward = items.pick_random()
	ItemDropService.drop_item(reward, reward_location.global_position)
