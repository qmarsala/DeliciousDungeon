extends Node2D

#poc: multi scenes
@export var outdoors: PackedScene
@export var dungeon: PackedScene
@export var main_menu: PackedScene
@export var damage_number: PackedScene

@export var bounty_one: BountyQuest
@export var bounty_two: BountyQuest
@export var bounty_three: BountyQuest
@export var action_quest: ActionQuest

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
var game_started = false
var current_scene
var next_scene

func _ready():
	SignalBusService.SceneChange.connect(_toggle_levels)
	#temp: should go to a damage number service in the main scene
	SignalBusService.DamageReceived.connect(_add_damage_number)
	
	#temp: quest poc
	wire_quests()
	_change_scene(main_menu, true)

func wire_quests():
	SignalBusService.EnemyDied.connect(bounty_one.on_enemy_died)
	SignalBusService.EnemyDied.connect(bounty_two.on_enemy_died)
	SignalBusService.EnemyDied.connect(bounty_three.on_enemy_died)
	bounty_one.QuestCompleted.connect(on_quest_completed)
	bounty_two.QuestCompleted.connect(on_quest_completed)
	bounty_three.QuestCompleted.connect(on_quest_completed)
	
	SignalBusService.ActionPerformed.connect(action_quest.on_action)
	action_quest.QuestCompleted.connect(on_quest_completed)
	
	$QuestLogLayer/VBoxContainer/BountyQuest.quest = bounty_one
	$QuestLogLayer/VBoxContainer/BountyQuest2.quest = bounty_two
	$QuestLogLayer/VBoxContainer/BountyQuest3.quest = bounty_three
	$QuestLogLayer/VBoxContainer/ActionQuest.quest = action_quest

func _toggle_levels():
	if not game_started:
		game_started = true
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
	if game_started and !$QuestLogLayer/VBoxContainer.visible:
		$QuestLogLayer/VBoxContainer.show()

func _game_over():
	$QuestLogLayer/VBoxContainer.hide()
	game_started = false
	action_quest.progress = 0
	bounty_one.progress = 0
	bounty_two.progress = 0
	bounty_three.progress = 0
	_change_scene(main_menu)

func _add_damage_number(damage: float, position: Vector2):
	var instance = damage_number.instantiate() as Label
	instance.text = String.num(damage)
	instance.global_position = position
	add_child(instance)

# quest service?
# should encompas hooking up quest events
# managing a list of multiple quests
# showing and hiding quests, playing notification sounds
# probably would be moving these to a completed list and then they would no longer show
# in the active quests 
func on_quest_completed(completed_quest_name: String):
	print("Quest completed: ", completed_quest_name)
	#global sounds? how do we not care how far from source you are? just use a big number?
	$QuestCompletedSound.play()
	if $QuestLogLayer/VBoxContainer/BountyQuest.quest.name == completed_quest_name:
		$QuestLogLayer/VBoxContainer/BountyQuest.hide()
	elif $QuestLogLayer/VBoxContainer/BountyQuest2.quest.name == completed_quest_name:
		$QuestLogLayer/VBoxContainer/BountyQuest2.hide()
	elif $QuestLogLayer/VBoxContainer/BountyQuest3.quest.name == completed_quest_name:
		$QuestLogLayer/VBoxContainer/BountyQuest3.hide()
	else:
		$QuestLogLayer/VBoxContainer/ActionQuest.hide()
