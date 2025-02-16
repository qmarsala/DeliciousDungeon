extends Node

var save_load: SaveLoad = SaveLoad.new()
var game_data: GameData2 = GameData2.new()

func _ready() -> void:
	game_data = save_load.load_game_data()

func save() -> void:
	save_load.save_game_data(game_data)
