class_name AbilityBar
extends Node

var slots: Array[AbilitySlot]

func _ready() -> void:
	for c in get_children():
		if c is AbilitySlot:
			slots.append(c)

func bind_weapon(weapon: WeaponData):
	for i in weapon.abilities.size():
		if i >= slots.size(): return
		if slots[i].is_bound:
			slots[i].unbind_ability()
		slots[i].bind_ability(weapon.abilities[i].ability_id)

func unbind_slots():
	for slot in slots:
		slot.unbind_ability()
