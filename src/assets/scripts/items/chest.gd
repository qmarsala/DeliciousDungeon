class_name Chest
extends Node2D

@export var spawn_rate: float = 1
@export var is_locked: bool = false
@export var pickup_scene: PackedScene
@export var items: Array[Item]

@onready var reward_location: Node2D = $RewardLocation

var is_open = false

func _ready() -> void:
	if randf() > spawn_rate:
		queue_free()
		return
	add_to_group(Interfaces.Interactable)

# interact as a component?
# if so - strategy pattern for what to do on interact?
func interact(player: Player):
	if is_locked or is_open:
		return # todo check for key
	is_open = true
	$Open.show()
	$Closed.hide()
	var reward = items.pick_random()
	if pickup_scene:
		var drop_instance = pickup_scene.instantiate()
		drop_instance.item = reward
		reward_location.add_child.call_deferred(drop_instance)
