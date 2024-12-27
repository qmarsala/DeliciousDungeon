extends Control


var quest: Quest

func _ready() -> void:
	SignalBusService.QuestCompleted.connect(on_quest_completed)

func _process(delta: float) -> void:
	if quest:
		$QuestDetails/QuestName.text = quest.name
		$QuestDetails/QuestDescription.text = quest.description
		$QuestDetails/QuestDescription2.text = str(quest.progress) + "/" + str(quest.count)

func on_quest_completed(q: Quest):
	if q == quest:
		queue_free()
