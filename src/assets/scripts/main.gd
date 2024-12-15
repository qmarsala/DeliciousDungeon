extends Node2D

#poc: multi scenes
#todo: 'global' script? for game/scene management?
@export var outdoors: PackedScene
@export var dungeon: PackedScene
@export var main_menu: PackedScene
@onready var world: Node2D = $World
@onready var animation_player: AnimationPlayer = $TransitionLayer/AnimationPlayer

#need to keep track of player data... is this where 'RefCounted' comes in?
# how do we want to track this? for now maybe we can pass in a dictionary or something?

var player_items: Dictionary = {
	"food": 0,
	"wood": 0
}

var is_outdoors = false
var current_scene
var next_scene

func _ready():
	_change_scene(main_menu, true)

func _toggle_levels():
	if is_outdoors:
		next_scene = dungeon
		is_outdoors = false
	else:
		next_scene = outdoors
		is_outdoors = true
	_change_scene.call_deferred(next_scene)

func _change_scene(scene: PackedScene, force: bool = false):
	next_scene = scene
	if force:
		_perform_scene_change()
	else:
		world.process_mode = Node.PROCESS_MODE_DISABLED
		animation_player.play("change_scene")

func _perform_scene_change():
	if current_scene:
		current_scene.queue_free()
	current_scene = next_scene.instantiate() as Level
	current_scene.ChangeLevel.connect(_toggle_levels)
	#todo: probably would want a reference to the player at the game level?
	# and reposition the player in the new scene?
	for c in current_scene.get_children():
		if c.is_in_group("Player"):
			var player = c as Player
			player.PlayerDied.connect(_game_over)
			player.player_items = player_items
			print(player.player_items)
	world.add_child.call_deferred(current_scene)
	world.process_mode = Node.PROCESS_MODE_INHERIT

func _game_over():
	_change_scene(main_menu)
	
