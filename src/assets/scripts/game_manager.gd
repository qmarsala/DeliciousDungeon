extends Node

#what all should we bring into the game service?
#player, game over events?
#main should just focus on getting the game setup and ready to run
# then this class can take over from there.

var game_started: bool

func start_game() -> void:
	game_started = true
	
func game_over() -> void:
	game_started = false
