extends Node2D

#poc: multi scenes
@export var outdoors: PackedScene
@export var dungeon: PackedScene
@export var main_menu: PackedScene
@export var damage_number: PackedScene
@onready var world: Node2D = $World
@onready var animation_player: AnimationPlayer = $TransitionLayer/AnimationPlayer
@onready var outdoor_music: AudioStreamPlayer2D = $OutdoorMusic
@onready var dungeon_music: AudioStreamPlayer2D = $DungeonMusic

#need to keep track of player data... is this where 'RefCounted' comes in?
# how do we want to track this? for now maybe we can pass in a dictionary or something?

var player_items: Dictionary = {
	Enums.Items.Wood: 0,
	Enums.Items.Food: 0
}

var is_outdoors = false
var current_scene
var next_scene

func _ready():
	SignalBusService.SceneChange.connect(_toggle_levels)
	#temp here: should go to a damage number service in the main scene
	SignalBusService.DamageReceived.connect(_add_damage_number)
	_change_scene(main_menu, true)

func _toggle_levels():
	if is_outdoors:
		next_scene = dungeon
		is_outdoors = false
		outdoor_music.stop()
		dungeon_music.play()
	else:
		next_scene = outdoors
		is_outdoors = true
		dungeon_music.stop()
		outdoor_music.play()
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
	current_scene = next_scene.instantiate()
	#todo: probably would want a reference to the player at the game level?
	# and reposition the player in the new scene?
	for c in current_scene.get_children():
		if c.is_in_group("Player"):
			var player = c as Player
			player.PlayerDied.connect(_game_over)
			player.player_items = player_items
			print(player.player_items)
			break
	world.add_child.call_deferred(current_scene)
	world.process_mode = Node.PROCESS_MODE_INHERIT

func _game_over():
	_change_scene(main_menu)

func _add_damage_number(damage: float, position: Vector2):
	var instance = damage_number.instantiate() as Label
	instance.text = String.num(damage)
	instance.global_position = position
	add_child(instance)
