extends Node2D

#todo:
# load game data
# new game
# continue game
# increase dungeon level when completing dungeon floor

@export var dungeon: PackedScene
@export var main_menu: PackedScene
@export var damage_number: PackedScene
@export var quests: Array[Quest]

@onready var world: Node2D = $World
@onready var animation_player: AnimationPlayer = $TransitionLayer/AnimationPlayer
@onready var quest_log_ui: Control = $QuestLogLayer/QuestLogUI

@export var game_data: GameData = GameData.new()

var current_scene_type: Enums.Scenes = Enums.Scenes.Main
var current_scene: Node2D
var next_scene: PackedScene

func _ready():
	SignalBusService.SceneChange.connect(_change_level)
	#temp: should go to a damage number service in the main scene
	SignalBusService.DamageReceived.connect(_add_damage_number)
	SignalBusService.QuestCompleted.connect(on_quest_completed)
	# quests specific to each dungeon floor?
	QuestSystemService.add_quests(quests)
	quest_log_ui.init()
	_change_scene(main_menu, true)
	$OutdoorMusic.play()

func _change_level(scene: Enums.Scenes):
	if scene == Enums.Scenes.Dungeon:
		if not game_data.game_started:
			game_data.start_game()
		game_data.current_floor += 1
		next_scene = dungeon
		$OutdoorMusic.stop()
		$DungeonMusic.play()
	else:
		$DungeonMusic.stop()
		$OutdoorMusic.play()
		next_scene = main_menu
	current_scene_type = scene
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
	for c in world.get_children():
		c.queue_free()
	
	current_scene = next_scene.instantiate()
	current_scene.init(game_data)
	#todo: probably would want a reference to the player at the game level?
	# and reposition the player in the new scene?
	for c in current_scene.get_children():
		if c.is_in_group("Player"):
			var player = c as Player
			player.player_died.connect(_game_over)
			player.player_data = game_data.player_data
			break
	world.add_child.call_deferred(current_scene)
	world.process_mode = Node.PROCESS_MODE_INHERIT
	if game_data.game_started and !$QuestLogLayer.visible and current_scene_type != Enums.Scenes.Main:
		$QuestLogLayer.show()

func _game_over():
	QuestSystemService.reset_quests()
	# what is the role of game manager? do we need it?
	game_data.end_game()
	if $QuestLogLayer.visible:
		$QuestLogLayer.hide()
	_change_level(Enums.Scenes.Main)

# todo: move to notify service or something like that
func _add_damage_number(damage: float, position: Vector2, is_target_player: bool):
	#todo: pull this into a damage number type?
	var instance = damage_number.instantiate() as DamageNumber
	instance.init(damage, position, is_target_player)
	add_child(instance)

# sound service?
func on_quest_completed(completed_quest: Quest):
	$QuestCompletedSound.play()
