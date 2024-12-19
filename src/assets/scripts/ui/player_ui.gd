extends Control
class_name PlayerUI

@export var player: Player

@onready var health_bar: ProgressBar = %HealthBar
@onready var hunger_bar: ProgressBar = %HungerBar
@onready var charged_attack_bar: ProgressBar = %ChargedAttackBar
@onready var food_count_label: Label = %FoodCountLabel
@onready var wood_count_label: Label = %WoodCountLabel
@onready var status_label: Label = %StatusLabel
@onready var dash_icon: Label = %DashIcon

var dash_icon_hidden = false

func _process(delta: float) -> void:
	update_health_bar(player.health)
	update_hunger_bar(player.nutrition)
	update_food_count(player.player_items[Enums.Items.Food])
	update_wood_count(player.player_items[Enums.Items.Wood])
	update_status_label(player.rest_is_cooldown)
	# todo: need a better way to wire up the cast bar
	# don't like going into the magic_attack.cast_timer
	# probably want signals for this? so we don't need to check weapon equipped here?
	if player.weapon_equipped and not player.magic_attack.cast_timer.is_stopped():
		update_charge_bar(100 - (player.magic_attack.cast_timer.time_left/player.magic_attack.spell_data.cast_time) * 100)
	else:
		update_charge_bar(0)
	if player.is_dash_cooldown:
		dash_icon.hide()
		dash_icon_hidden = true
	elif dash_icon_hidden:
		dash_icon.show()
		dash_icon_hidden = false

func update_health_bar(health):
	if health_bar:
		health_bar.value = health
		
func update_hunger_bar(nutrition):
	if hunger_bar:
		hunger_bar.value = nutrition

func update_food_count(food_count):
	if food_count_label:
		food_count_label.text = "Food: " + str(food_count)
		
func update_wood_count(wood_count):
	if wood_count_label:
		wood_count_label.text = "Wood: " + str(wood_count)

var status_map: Dictionary = {
	true: "Rested",
	false: "Tired"
}
func update_status_label(status):
	if status_label:
		status_label.text = "Status: " + status_map[status]

func update_charge_bar(charge):
	if charged_attack_bar:
		if charge == 0: 
			charged_attack_bar.hide()
		else:
			charged_attack_bar.show()
			charged_attack_bar.value = charge
