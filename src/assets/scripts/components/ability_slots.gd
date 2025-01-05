class_name AbilitySlots
extends Node

var slots: Array[AbilitySlot] = []

func _ready() -> void:
	slots = get_children() as Array[AbilitySlot]

func bind_abilities(weapon: Weapon) -> void:
	for i in slots.size():
		var weapon_data = weapon.weapon_data
		if i < weapon_data.weapon_abilities.size():
			var ability = weapon_data.weapon_abilities[i]
			slots[i].init(weapon, ability)
			slots[i].use_requested.connect(weapon.on_use_ability_requested)
			slots[i].use_pressed.connect(weapon.on_use_ability_pressed)

# not sure if we need this, deleting the weapon will disconnect it
# if we need to swap abilities without deleting the weapon this would be needed.
func unbind_abilities(weapon: Weapon) -> void:
	for i in slots.size():
		var weapon_data = weapon.weapon_data
		if i < weapon_data.weapon_abilities.size():
			if slots[i].use_requested.is_connected(weapon.on_use_ability_requested):
				slots[i].use_requested.disconnect(weapon.on_use_ability_requested)
			if slots[i].use_requested.is_connected(weapon.on_use_ability_pressed):
				slots[i].use_pressed.disconnect(weapon.on_use_ability_pressed)
