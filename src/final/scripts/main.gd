extends Node

var save_load: SaveLoad = SaveLoad.new()
var game_data: GameData = GameData.new()

@onready var new_game_label: Label = $NewGameLabel
@onready var player: Player2 = $YSort/Player

func _ready() -> void:
	game_data = save_load.load_game_data()
	if game_data.current_level == 0:
		new_game_label.show()
	else:
		new_game_label.hide()
	player.init(game_data.player_data)

func save() -> void:
	player.save()
	save_load.save_game_data(game_data)
