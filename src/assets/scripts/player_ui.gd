extends Control
class_name PlayerUI

@export var player: Player

@onready var health_bar: ProgressBar = $HealthBar
@onready var hunger_bar: ProgressBar = $HungerBar
@onready var charged_attack_bar: ProgressBar = $ChargedAttackBar
@onready var food_count_label: Label = $FoodCountLabel

func _process(delta: float) -> void:
	update_health_bar(player.health)
	update_hunger_bar(player.nutrition)
	update_food_count(player.food)
	# todo: need a better way to wire up the cast bar
	# don't like going into the magic_attack.cast_timer
	if not player.magic_attack.cast_timer.is_stopped():
		update_charge_bar(100 - player.magic_attack.cast_timer.time_left * player.magic_attack.spell_data.cast_time * 1000)
	else:
		update_charge_bar(0)

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
		if charge == 0: 
			charged_attack_bar.hide()
		else:
			charged_attack_bar.show()
			charged_attack_bar.value = charge
