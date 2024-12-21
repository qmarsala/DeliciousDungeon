class_name DungeonManager
extends Node2D

#todo: track what floor you are on, and go back to previous floor/next floor
# idea: node for each floor, to make going back and forth easier?
# problem: do we put the floors in different areas far enough apart we know
# it wont be a problem? or do we 'disable and hide' the previous and next floors?

var player: Player
var current_floor: int = 0

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is Player:
			player = child
			return


# todo: signal on global bus to change scene should happen here
# use internal signals to go between floors
