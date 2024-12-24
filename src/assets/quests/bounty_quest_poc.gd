class_name BountyQuest
extends Quest

@export var target_enemy_id: Enums.Enemies = Enums.Enemies.None

# is this where we want this?
# how do we want to handle different types of quests like 'bounty' vs 'interactions'
# and quest steps?
func on_enemy_died(enemy_id: Enums.Enemies):
	if enemy_id == target_enemy_id:
		log_progress(1)
