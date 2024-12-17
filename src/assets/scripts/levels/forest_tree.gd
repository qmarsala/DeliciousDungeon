class_name ForestTree
extends StaticBody2D

@export var felled_tree_top: PackedScene
@export var wood_item: Item
@export var pickup_scene: PackedScene

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var health_component: HealthComponent = $HealthComponent

func _init() -> void:
	add_to_group("Interactable", true)

func interact(player: Player) -> void:
	chop()

func chop():
	if health_component.is_dead(): return
	
	health_component.take_damage(1)
	if health_component.is_dead():
		create_stump()
		animate_fell()
		drop_logs()

func create_stump():
	#todo: want to create a new spirte that is an actual stump, for now just shortening the displayed view
	var rect = sprite_2d.region_rect
	sprite_2d.rotation_degrees = 0
	sprite_2d.region_rect = Rect2(rect.position.x, rect.position.y + 15, rect.size.x, rect.size.y - 14)
	sprite_2d.global_position = Vector2(sprite_2d.global_position.x, sprite_2d.global_position.y + 8)

func animate_fell():
	if felled_tree_top:
		var instance = felled_tree_top.instantiate() as Node2D
		add_child.call_deferred(instance)

func drop_logs():
	if pickup_scene:
		var dropInstance = pickup_scene.instantiate()
		dropInstance.item = wood_item
		var xfac = randi_range(-1,1)
		if xfac == 0:
			xfac = 1
		var x = global_position.x + randf_range(5,7) * xfac
		var yfac = randi_range(-1,1)
		if yfac == 0:
			yfac = -1
		var y = global_position.y + randf_range(5,7) * yfac
		dropInstance.position = Vector2(x, y)
		get_tree().root.add_child(dropInstance)
