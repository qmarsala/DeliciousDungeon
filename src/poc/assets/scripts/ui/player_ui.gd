extends Control
class_name PlayerUI

@export var player: Player

@onready var health_bar: ProgressBar = %HealthBar
@onready var hunger_bar: ProgressBar = %HungerBar
@onready var cast_bar: ProgressBar = %CastBar
@onready var rest_bar: ProgressBar = %RestBar
@onready var food_count_label: Label = %FoodCountLabel
@onready var wood_count_label: Label = %WoodCountLabel
@onready var status_label: Label = %StatusLabel
@onready var ability_1_cooldown: TextureProgressBar = $Ability1Cooldown
@onready var ability_2_cooldown: TextureProgressBar = $Ability2Cooldown
@onready var ability_3_cooldown: TextureProgressBar = $Ability3Cooldown
@onready var dash_cooldown: TextureProgressBar = $DashCooldown

var ability_slots: Array[AbilitySlot]
var ability_cooldowns: Array[TextureProgressBar]

func _ready() -> void:
	SignalBus.Casting.connect(update_cast_bar)
	SignalBus.Resting.connect(update_rest_bar)
	player.equipped_weapon.connect(setup_ability_bar)
	player.unequipped_weapon.connect(teardown_ability_bar)
	ability_cooldowns = [ability_1_cooldown, ability_2_cooldown, ability_3_cooldown]

func _process(delta: float) -> void:
	update_health_bar(player.health_component.health)
	update_hunger_bar(player.player_data.nutrition)
	update_food_count(player.player_data.items[Enums.Items.Food])
	update_wood_count(player.player_data.items[Enums.Items.Wood])
	update_status_label(player.rest_is_cooldown)
	update_status_effects_label(player.status_effects_component)
	update_ability_cooldowns()

func setup_ability_bar(weapon: Weapon):
	if player.weapon_equipped:
		ability_slots = player.ability_slots.slots

func teardown_ability_bar():
	if not player.weapon_equipped:
		ability_slots = []
		update_cast_bar(0, 100)

func update_health_bar(health):
	if health_bar:
		health_bar.value = health
		
func update_hunger_bar(nutrition):
	if hunger_bar:
		hunger_bar.value = nutrition

func update_food_count(food_count):
	if food_count_label:
		food_count_label.text = str(food_count)
		
func update_wood_count(wood_count):
	if wood_count_label:
		wood_count_label.text = str(wood_count)

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

func update_status_effects_label(status_effect_component: StatusEffectComponent):
	var status_effects_text = "Status Effects:\n"
	if status_effect_component.status_effects.size() < 1:
		$StatusEffectsLabel.hide()
		return
	
	$StatusEffectsLabel.show()
	for se in status_effect_component.status_effects:
		status_effects_text += se.effect_name + "\n"
		print(status_effects_text)
	$StatusEffectsLabel.text = status_effects_text

func update_ability_cooldowns():
	dash_cooldown.value = get_progress_value(player.dash_cooldown_timer.time_left, player.player_data.dash_cooldown)
	if player.weapon_equipped:
		for i in ability_slots.size():
			ability_cooldowns[i].value = get_progress_value(ability_slots[i].cooldown_timer.time_left, ability_slots[i].total_cooldown)

func get_progress_value(time_left: float, total_time: float):
	return 100 - (time_left / total_time) * 100

func update_cast_bar(time_left: float, total_time: float):
	if cast_bar:
		var progress = get_progress_value(time_left, total_time)
		if progress <= 1 or progress >= 99: 
			$BarBackground.hide()
			cast_bar.hide()
		else:
			$BarBackground.show()
			cast_bar.show()
			cast_bar.value = progress

func update_rest_bar(time_left: float, total_time: float):
	if rest_bar:
		var progress = get_progress_value(time_left, total_time)
		if progress <= 1 or progress >= 99: 
			$BarBackground.hide()
			rest_bar.hide()
		else:
			$BarBackground.show()
			rest_bar.show()
			rest_bar.value = progress
