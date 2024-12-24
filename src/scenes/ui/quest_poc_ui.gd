extends Control


var quest: Quest


func _process(delta: float) -> void:
	if quest:
		$QuestName.text = quest.name
		$QuestDescription.text = quest.description
		$QuestDescription2.text = str(quest.progress) + "/" + str(quest.count)
