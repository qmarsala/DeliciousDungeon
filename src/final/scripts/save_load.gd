class_name SaveLoad
extends RefCounted

var save_game_path = "user://game_data.res"

func load_game_data() -> GameData:
	if not ResourceLoader.exists(save_game_path):
		reset_game_data()
	var saved_game_data = ResourceLoader.load(save_game_path)
	if saved_game_data:
		return saved_game_data
	else:
		return GameData.new()

func reset_game_data() -> void:
	save_game_data(GameData.new())

func save_game_data(game_data: GameData) -> void:
	var result = ResourceSaver.save(game_data, save_game_path)
	if result != OK:
		printerr("Unable to save game!")
