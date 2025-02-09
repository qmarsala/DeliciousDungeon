class_name ActionQuest
extends Quest

#todo: we want to make sure enemies dying to traps without the player involved
# count in a bounty, maybe we can use action id for all quests and 
# have the signal for enemies dying when a player is invovled be something else
# from it just dying?
@export var target_action_id: Enums.Actions = Enums.Actions.None

# is this where we want this?
# how do we want to handle different types of quests like 'bounty' vs 'interactions'
# and quest steps?
func on_action(action_id: Enums.Actions):
	if action_id == target_action_id:
		log_progress(1)
