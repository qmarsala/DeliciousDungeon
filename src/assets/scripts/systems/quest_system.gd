class_name QuestSystem
extends Node

#if quest system is a global service
# how do we feed it data?
# there are three lists really: available (in the game) inprogress (ones we are currently doing) and completed
# for now avail and inprog are the same list
# does the quest system read files itself somehow?
# does it get fed in from another context like 'game'?

var available_quests: Array[Quest]
var completed_quests: Array[Quest]

func _ready() -> void:
	SignalBusService.QuestCompleted.connect(on_quest_completed)

# maybe this should be in each quests under a start method?
# what about when the game is closed and reopened? how do signal connections work with saved progress?
# maybe the quest system still needs to make sure this happens?
func wire_quests():
	for q in available_quests:
		wire_quest(q)

func wire_quest(q: Quest):
	if q is BountyQuest:
		if !SignalBusService.EnemyDied.is_connected(q.on_enemy_died):
			SignalBusService.EnemyDied.connect(q.on_enemy_died)
	elif q is ActionQuest:
		if !SignalBusService.ActionPerformed.is_connected(q.on_action):
			SignalBusService.ActionPerformed.connect(q.on_action)
			
func add_quest(new_quest: Quest):
	if new_quest.completed:
		completed_quests.append(new_quest)
	else:
		available_quests.append(new_quest)
		wire_quest(new_quest)

func add_quests(new_quests: Array[Quest]):
	completed_quests.append_array(new_quests.filter(func(q): return q.completed))
	available_quests.append_array(new_quests.filter(func(q): return !q.completed))
	wire_quests()

func on_quest_completed(completed_quest: Quest):
	available_quests.erase(completed_quest)
	completed_quests.append(completed_quest)
