extends Control


var quest: Quest

func _ready() -> void:
	SignalBus.QuestCompleted.connect(on_quest_completed)

func _process(delta: float) -> void:
	if quest:
		$QuestDetails/QuestName.text = "Quest: " + quest.name
		$QuestDetails/QuestDescription.text = quest.description
		$QuestDetails/QuestRewardDescription.text = "Reward: " + quest.reward.description
		$QuestDetails/QuestDescription2.text = str(quest.progress) + "/" + str(quest.count)

func on_quest_completed(q: Quest):
	if q == quest:
		queue_free()
