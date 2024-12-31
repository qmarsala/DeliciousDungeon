extends Control
class_name PlayerUI

@export var player: Player

@onready var health_bar: ProgressBar = %HealthBar
@onready var hunger_bar: ProgressBar = %HungerBar
@onready var charged_attack_bar: ProgressBar = %ChargedAttackBar
@onready var food_count_label: Label = %FoodCountLabel
@onready var wood_count_label: Label = %WoodCountLabel
@onready var status_label: Label = %StatusLabel
@onready var ability_1_cooldown: ProgressBar = $Ability1Cooldown
@onready var ability_2_cooldown: ProgressBar = $Ability2Cooldown
@onready var ability_3_cooldown: ProgressBar = $Ability3Cooldown
@onready var dash_cooldown: ProgressBar = $DashCooldown

func _ready() -> void:
	SignalBusService.AttackCharge.connect(update_charge_bar)
	

func _process(delta: float) -> void:
	update_health_bar(player.health_component.health)
	update_hunger_bar(player.nutrition)
	update_food_count(player.player_items[Enums.Items.Food])
	update_wood_count(player.player_items[Enums.Items.Wood])
	update_status_label(player.rest_is_cooldown)
	update_ability_cooldowns()

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
	true: "Full",
	false: "Hungry"
}
func update_status_label(status):
	if status_label:
		var status_text = status_map[status]
		if hunger_bar.value == 0:
			status_text = "Starving"
		status_label.text = status_text


func update_ability_cooldowns():
	dash_cooldown.value = get_progress_value(player.dash_cooldown_timer.time_left, player.DASH_COOLDOWN)
	if player.weapon_equipped:
		#todo: change this, should these signal?
		# or should there be a mediator for this stuff?
		# we also only need to grab this once when the weapon is equipped, maybe an event for that too?
		# we could use a weapon equipped event to wire this up
		# we need a contract around 'weapon or abilities' to gain the data about
		# an ability such as (name, total_cooldown, current_cooldown)
		var ability_slots = player.weapon.ability_slots.get_children()
		var ability1 = ability_slots[0] as Ability
		var ability2 = ability_slots[1] as Ability
		var ability3 = ability_slots[2] as Ability
		ability_1_cooldown.value = get_progress_value(ability1.cooldown_timer.time_left, ability1.total_cooldown)
		ability_2_cooldown.value = get_progress_value(ability2.cooldown_timer.time_left, ability2.total_cooldown) 
		ability_3_cooldown.value = 0 # get_progress_value(ability3.cooldown_timer.time_left, ability3.ability_data.cooldown) 

func get_progress_value(time_left: float, total_time: float):
	return 100 - (time_left / total_time) * 100

func update_charge_bar(time_left: float, total_time: float):
	if charged_attack_bar:
		var charge = get_progress_value(time_left, total_time)
		if charge <= 1 or charge >= 99: 
			charged_attack_bar.hide()
		else:
			charged_attack_bar.show()
			charged_attack_bar.value = charge
