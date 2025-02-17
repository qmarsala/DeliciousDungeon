class_name SceneManager
extends Node

@export var main_menu_scene: PackedScene
@export var outdoor_scenes: Array[PackedScene]

@export var canyon_dungeon_scene: PackedScene
@export var cave_dungeon_scene: PackedScene
@export var fort_dungeon_scene: PackedScene

@onready var animation_player: AnimationPlayer = $TransitionLayer/AnimationPlayer

var world: Node

var next_scene: PackedScene
var next_scene_level: int
var current_scene_instance: Node

var changing_scene: bool = false

func _ready() -> void:
	world = get_tree().get_first_node_in_group("World")
	if not world: 
		printerr("Could not find world node, scene manager not initialized!")
		return
		
	if SignalBus.SceneChange.is_connected(queue_scene_change):
		SignalBus.SceneChange.disconnect(queue_scene_change)
	SignalBus.SceneChange.connect(queue_scene_change)

func queue_scene_change(event: SceneChangeEvent) -> void:
	print("queue_scene_change")
	
	if changing_scene:
		return 
	changing_scene = true
	world.process_mode = Node.PROCESS_MODE_DISABLED
	
	next_scene_level = event.level
	if event.scene_type == Enums.Scenes.Main:
		next_scene = main_menu_scene
	elif event.scene_type == Enums.Scenes.Outdoors:
		next_scene = outdoor_scenes.pick_random()
	else:
		if event.level < 4:
			next_scene = canyon_dungeon_scene
		elif event.level < 9:
			next_scene = cave_dungeon_scene
		else:
			next_scene = fort_dungeon_scene
	
	animation_player.play("scene_change")
	

func perform_scene_change() -> void:
	print("preform_scene_change")
	
	if current_scene_instance:
		current_scene_instance.queue_free()
	for c in world.get_children():
		if c.is_in_group("Player"):
			c.global_position = Vector2.ZERO
		else:
			c.queue_free()
	
	current_scene_instance = next_scene.instantiate()
	current_scene_instance.init(next_scene_level)
	
	world.add_child.call_deferred(current_scene_instance)
	world.process_mode = Node.PROCESS_MODE_INHERIT
	changing_scene = false
