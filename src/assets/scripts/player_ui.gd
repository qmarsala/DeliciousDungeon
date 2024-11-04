extends Control
class_name PlayerUI

@onready var health_bar: ProgressBar = $HealthBar
@onready var hunger_bar: ProgressBar = $HungerBar

func update_health_bar(health):
	if health_bar:
		health_bar.value = health
		
func update_hunger_bar(nutrition):
	if hunger_bar:
		hunger_bar.value = nutrition
