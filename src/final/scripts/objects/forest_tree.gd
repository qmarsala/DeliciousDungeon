class_name ForestTree
extends StaticBody2D

@export var felled_tree_top: PackedScene
@export var wood_item: Item

@export var spawn_chance: float = 1
@export var drop_chance: float = 1

@onready var health_component: HealthComponent = $HealthComponent
@onready var interactbox: InteractBox = $Interactbox

func _init() -> void:
	add_to_group(Interfaces.Interactable, true)

func interact(player: Player2) -> void:
	chop()

func _ready() -> void:
	if randf() > spawn_chance:
		queue_free()
		return
	
	var size = randf_range(0.85, 1.15)
	apply_scale(Vector2(size, size))
	interactbox.interacted.connect(interact)

func chop() -> void:
	if health_component.is_dead(): return
	health_component.receive_damage(1)

func create_stump():
	$TreeStump.show()
	$Sprite2D.hide()

func animate_fell():
	if felled_tree_top:
		var instance = felled_tree_top.instantiate() as Node2D
		add_child.call_deferred(instance)

func drop_logs():
	if randf() > 1 - drop_chance:
		ItemDropper.drop_item(wood_item, global_position)
