extends Control
class_name PlayerUI

@onready var health_bar: ProgressBar = $HealthBar
@onready var hunger_bar: ProgressBar = $HungerBar
@onready var charged_attack_bar: ProgressBar = $ChargedAttackBar
@onready var food_count_label: Label = $FoodCountLabel

func update_health_bar(health):
	if health_bar:
		health_bar.value = health
		
func update_hunger_bar(nutrition):
	if hunger_bar:
		hunger_bar.value = nutrition

func update_food_count(food_count):
	if food_count_label:
		food_count_label.text = "Food: " + str(food_count)

func update_charge_bar(charge):
	if charged_attack_bar:
		charged_attack_bar.value = charge
