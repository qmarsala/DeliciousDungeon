class_name Game
extends Node2D

#poc: multi scenes
#todo: 'global' script? for game/scene management?
@export var outdoors: PackedScene
@export var dungeon: PackedScene

var is_outdoors = true
var current_scene

func _ready():
	_change_scene(outdoors)

func _toggle_levels():
	var next_scene = current_scene
	if is_outdoors:
		next_scene = dungeon
		is_outdoors = false
	else:
		next_scene = outdoors
		is_outdoors = true
	_change_scene(next_scene)

func _change_scene(next_scene: PackedScene):
	if current_scene:
		current_scene.queue_free()
	current_scene = next_scene.instantiate() as Level
	current_scene.ChangeLevel.connect(_toggle_levels)
	#todo: probably would want a reference to the player at the game level?
	# and reposition the player in the new scene?
	for c in current_scene.get_children():
		if c.is_in_group("Player"):
			var player = c as Player
			player.PlayerDied.connect(_toggle_levels)
	get_tree().root.add_child.call_deferred(current_scene)
