class_name QuestSystem
extends Node


@export var available_quests: Array[Quest]

var completed_quests: Array[Quest]

func wire_quests():
	for q in available_quests:
		if q is BountyQuest:
			SignalBusService.EnemyDied.connect(q.on_enemy_died)
		elif q is ActionQuest:
			SignalBusService.ActionPerformed.connect(q.on_action)
