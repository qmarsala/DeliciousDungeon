extends Node2D

#poc: multi scenes
#todo: 'global' script? for game/scene management?
@export var outdoors: PackedScene
@export var dungeon: PackedScene
@onready var world: Node2D = $World
@onready var animation_player: AnimationPlayer = $TransitionLayer/AnimationPlayer

var is_outdoors = true
var current_scene
var next_scene

func _ready():
	_change_scene(outdoors)

func _toggle_levels():
	if is_outdoors:
		next_scene = dungeon
		is_outdoors = false
	else:
		next_scene = outdoors
		is_outdoors = true
	_change_scene(next_scene)

func _change_scene(scene: PackedScene):
	next_scene = scene
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
			player.PlayerDied.connect(_toggle_levels)
	world.add_child.call_deferred(current_scene)
	world.process_mode = Node.PROCESS_MODE_INHERIT
