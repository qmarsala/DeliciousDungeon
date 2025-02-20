class_name SceneManager
extends Node

@export var main_menu_scene: PackedScene
@export var outdoor_scenes: Array[PackedScene]
@export var canyon_dungeon_scenes: Array[PackedScene]
@export var cave_dungeon_scene: PackedScene
@export var fort_dungeon_scene: PackedScene

@onready var animation_player: AnimationPlayer = $TransitionLayer/AnimationPlayer

var world: Node
var game_data: GameData

var next_scene: PackedScene
var next_scene_level: int = 0
var current_scene_instance: GameScene

func init(world: Node, game_data: GameData) -> void:
	self.world = world
	if not self.world: 
		printerr("Could not find world node, scene manager not initialized!")
		return
	
	self.game_data = game_data
	if not self.game_data: 
		printerr("Could not find game_data, scene manager not initialized!")
		return
	
	current_scene_instance = main_menu_scene.instantiate()
	current_scene_instance.init(game_data.player_data, game_data.current_level)
	world.add_child(current_scene_instance)

func queue_scene_change(scene_type: Enums.Scenes) -> void:
	print("queue_scene_change")
	
	if scene_type == Enums.Scenes.Main:
		next_scene = main_menu_scene
	elif scene_type == Enums.Scenes.Outdoors:
		next_scene = outdoor_scenes.pick_random()
	else:
		if game_data.current_level < 3 && game_data.current_level < canyon_dungeon_scenes.size():
			next_scene = canyon_dungeon_scenes[game_data.current_level]
		elif game_data.current_level < 7 && cave_dungeon_scene:
			next_scene = cave_dungeon_scene
		elif fort_dungeon_scene:
			next_scene = fort_dungeon_scene
		else: 
			next_scene = main_menu_scene
	
	world.process_mode = Node.PROCESS_MODE_DISABLED
	animation_player.play("scene_change")

func perform_scene_change() -> void:
	print("preform_scene_change")
	for c in world.get_children():
		c.queue_free()
	
	current_scene_instance = next_scene.instantiate() as GameScene
	current_scene_instance.init(game_data.player_data, game_data.current_level)
	
	world.add_child(current_scene_instance)
	world.process_mode = Node.PROCESS_MODE_INHERIT
