extends Control

@export var quest_ui_scene: PackedScene

@onready var quest_container: VBoxContainer = $ScrollContainer/ActiveQuestsContainer

func init():
	$ToggleQuestLog.pressed.connect(on_toggle_pressed)
	var quests = QuestSystemService.available_quests
	var bounty_index = 0
	for q in quests:
		var qui = quest_ui_scene.instantiate()
		qui.quest = q
		quest_container.add_child(qui)

func on_toggle_pressed():
	if quest_container.visible:
		quest_container.hide()
	else:
		quest_container.show()
