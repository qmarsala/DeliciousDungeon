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

func _ready() -> void:
	SignalBusService.AttackCharge.connect(update_charge_bar)

func _process(delta: float) -> void:
	update_health_bar(player.health)
	update_hunger_bar(player.nutrition)
	update_food_count(player.player_items[Enums.Items.Food])
	update_wood_count(player.player_items[Enums.Items.Wood])
	update_status_label(player.rest_is_cooldown)
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
		var status_text = status_map[status]
		if hunger_bar.value == 0:
			status_text = "Starving"
		status_label.text = "Status: " + status_text

func update_charge_bar(time_left: float, total_time: float):
	if charged_attack_bar:
		var charge = 100 - (time_left / total_time) * 100
		if charge <= 1 or charge >= 99: 
			charged_attack_bar.hide()
		else:
			charged_attack_bar.show()
			charged_attack_bar.value = charge
