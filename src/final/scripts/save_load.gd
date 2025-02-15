class_name SaveLoad
extends RefCounted

var save_game_path = "user://game_data.res"

func load_game_data() -> GameData2:
	if not ResourceLoader.exists(save_game_path):
		save_game_data(GameData2.new())
	var saved_game_data = ResourceLoader.load(save_game_path)
	if saved_game_data:
		return saved_game_data
	else:
		return GameData2.new()

func save_game_data(game_data: GameData2) -> void:
	var result = ResourceSaver.save(game_data, save_game_path)
	if result != OK:
		printerr("Unable to save game!")
