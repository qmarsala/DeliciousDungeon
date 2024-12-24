extends Control


var quest: Quest

func _ready() -> void:
	SignalBusService.QuestCompleted.connect(on_quest_completed)

func _process(delta: float) -> void:
	if quest:
		$QuestName.text = quest.name
		$QuestDescription.text = quest.description
		$QuestDescription2.text = str(quest.progress) + "/" + str(quest.count)

func on_quest_completed(q: Quest):
	if q == quest:
		queue_free()
