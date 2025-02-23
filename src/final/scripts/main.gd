extends Node

@export var game_data: GameData

@onready var scene_manager: SceneManager = $SceneManager

var save_load: SaveLoad = SaveLoad.new()

func _ready() -> void:
	connect_signals()
	#load_game()
	game_data.current_level = 0
	GameTime.init($World)
	scene_manager.init($World, game_data)

func connect_signals() -> void:
	SignalBus.SceneChangeRequested.connect(handle_scene_change_requested)
	
func load_game() -> void:
	print("loading game.")
	game_data = save_load.load_game_data()

func save_game() -> void:
	print("saving game.")
	save_load.save_game_data(game_data)

func handle_scene_change_requested(event: SceneChangeRequestedEvent) -> void:
	if event.is_dungeon_floor_completion:
		game_data.current_level += 1
	save_game()
	scene_manager.queue_scene_change.call_deferred(event.scene_type)
