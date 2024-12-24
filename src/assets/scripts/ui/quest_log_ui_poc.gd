extends Control

func _ready():
	$ToggleQuestLog.pressed.connect(on_toggle_pressed)
	SignalBusService.QuestCompleted.connect(on_quest_completed)
	var quests = QuestSystemService.available_quests
	#todo: dynamically create and add quest ui's
	var bounty_index = 0
	for q in quests:
		if q is BountyQuest:
			if bounty_index == 0:
				$ActiveQuestsContainer/BountyQuest.quest = q
			elif bounty_index == 1:
				$ActiveQuestsContainer/BountyQuest2.quest = q
			elif bounty_index == 2:
				$ActiveQuestsContainer/BountyQuest3.quest = q
			bounty_index += 1
		else:
			$ActiveQuestsContainer/ActionQuest.quest = q

func on_toggle_pressed():
	if $ActiveQuestsContainer.visible:
		$ActiveQuestsContainer.hide()
	else:
		$ActiveQuestsContainer.show()

func on_quest_completed(completed_quest_name: String):
	#todo: quest ui should also listen to this event
	if $ActiveQuestsContainer/BountyQuest.quest.name == completed_quest_name:
		$ActiveQuestsContainer/BountyQuest.hide()
	elif $ActiveQuestsContainer/BountyQuest2.quest.name == completed_quest_name:
		$ActiveQuestsContainer/BountyQuest2.hide()
	elif $ActiveQuestsContainer/BountyQuest3.quest.name == completed_quest_name:
		$ActiveQuestsContainer/BountyQuest3.hide()
	else:
		$ActiveQuestsContainer/ActionQuest.hide()
