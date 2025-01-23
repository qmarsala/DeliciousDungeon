class_name GameData
extends Resource

@export var game_started: bool = false
@export var current_floor: int = 0
@export var starting_items: Dictionary = {
	Enums.Items.Wood: 1,
	Enums.Items.Food: 1
}
@export var player_data: PlayerData = PlayerData.new()
# perhaps buffs should be a diff system that status effects?
# they are similar though
#@export var player_buffs
@export var current_quest: Quest

func start_game():
	current_floor = 0
	player_data = PlayerData.new()
	player_data.items = starting_items
	game_started = true

func end_game():
	game_started = false
