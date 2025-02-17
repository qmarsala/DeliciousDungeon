extends Node

var save_load: SaveLoad = SaveLoad.new()
var game_data: GameData = GameData.new()

@onready var new_game_label: Label = $NewGameLabel
@onready var player: Player2 = $World/Player

func _ready() -> void:
	load_game()
	if game_data.current_level == 0:
		new_game_label.show()
	else:
		new_game_label.hide()

func load_game() -> void:
	game_data = save_load.load_game_data()
	player.init(game_data.player_data)

func save_game() -> void:
	player.save()
	save_load.save_game_data(game_data)
