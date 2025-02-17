extends Node

var save_load: SaveLoad = SaveLoad.new()
var game_data: GameData = GameData.new()

@onready var scene_manager: SceneManager = $SceneManager

func _ready() -> void:
	connect_signals()
	load_game()
	scene_manager.init($World, game_data.player_data)

func connect_signals() -> void:
	SignalBus.SceneChangeRequested.connect(handle_scene_change_requested)
	SignalBus.DungeonFloorCompleted.connect(handle_dungeon_floor_completed)
	
func load_game() -> void:
	print("loading game.")
	game_data = save_load.load_game_data()

#todo: could we call on shutdown too?
func save_game() -> void:
	print("saving game.")
	save_load.save_game_data(game_data)

func handle_scene_change_requested(event: SceneChangeRequestedEvent) -> void:
	save_game()
	scene_manager.queue_scene_change.call_deferred(event)

func handle_dungeon_floor_completed() -> void:
	game_data.current_level += 1
	var event = SceneChangeRequestedEvent.create(Enums.Scenes.Dungeon, game_data.current_level)
	scene_manager.queue_scene_change.call_deferred(event)
