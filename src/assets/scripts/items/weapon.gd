class_name Weapon
extends Node2D

@onready var ability_slots: AbilitySlots = $AbilitySlots

var player: Player

#temp way to show different levels of weapons
var weapon_scales: Dictionary = {
	1: .7,
	2: .8,
	3: .9
}

var weapon_data: WeaponData
func use_data(data: WeaponData):
	if data != null:
		weapon_data = data
		scale = Vector2.ONE * weapon_scales[weapon_data.weapon_level]

func equip(player: Player):
	self.player = player
	ability_slots.bind_abilities(self)

func unequip():
	player = null
	ability_slots.unbind_abilities(self)

func _process(delta: float) -> void:
	if not is_instance_valid(player): return
	var location = get_attack_location()
	handle_attack_indicator(location)
	handle_weapon_aim(location)

func get_attack_location() -> Vector2:
	var mouse_pos = player.get_global_mouse_position()
	var direction = mouse_pos - player.global_position
	var target_location = mouse_pos
	if direction.length() > weapon_data.max_range:
		target_location = player.global_position + (direction.normalized() * weapon_data.max_range)
	return target_location

func handle_attack_indicator(attack_location: Vector2) -> void:
	if not player.weapon_equipped:
		$AttackIndicator.hide()
	elif not $AttackIndicator.visible:
		$AttackIndicator.show()
	$AttackIndicator.global_position = attack_location

func handle_weapon_aim(attack_location: Vector2):
	pass

func handle_use_ability_animation(animation_name: String):
	pass

func on_use_ability_pressed(ability_slot: AbilitySlot):
	if player.health_component.is_dead() or not player.weapon == self: return
	handle_use_ability_animation(ability_slot.ability_data.animation_name)

func on_use_ability_requested(ability_slot: AbilitySlot):
	if player.health_component.is_dead() or not player.weapon == self: return
	ability_slot.use_ability(player.global_position, get_attack_location())
