extends Control

@export var quest_ui_scene: PackedScene

func init():
	$ToggleQuestLog.pressed.connect(on_toggle_pressed)
	var quests = QuestSystemService.available_quests
	var bounty_index = 0
	for q in quests:
		var qui = quest_ui_scene.instantiate()
		qui.quest = q
		$ActiveQuestsContainer.add_child(qui)

func on_toggle_pressed():
	if $ActiveQuestsContainer.visible:
		$ActiveQuestsContainer.hide()
	else:
		$ActiveQuestsContainer.show()
