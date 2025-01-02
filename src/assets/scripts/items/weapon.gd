class_name Weapon
extends Node2D

#something to thing about.
# seems like it would be cool if we had a weapon
# and that weapon could be a bow or sword or staff, or whatever
# and an npc could use it too.  Current design is only thinking of player

var player: Player

@onready var ability_slots: Node = $AbilitySlots

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

func _ready() -> void:
	for ability_slot in ability_slots.get_child_count():
		if ability_slot < weapon_data.weapon_abilities.size():
			var ability = weapon_data.weapon_abilities[ability_slot]
			var slot = ability_slots.get_child(ability_slot) as AbilitySlot
			slot.init(player, self, ability)
			slot.use_requested.connect(on_use_ability_requested)
			slot.use_pressed.connect(on_use_ability_pressed)

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

# this an the following method probably need to live somewhere else
# or use better params from the weapon we are representing.
# perhaps there could be an animatin controller with methods that
# our state machine could call into for things like 'idle'
func handle_weapon_aim(attack_location: Vector2):
	pass

func handle_use_ability_animation(animation_name: String):
	pass

func on_use_ability_pressed(ability_slot: AbilitySlot):
	if player.health_component.is_dead() or not player.weapon == self: return
	handle_use_ability_animation(ability_slot.ability_data.animation_name)

func on_use_ability_requested(ability_slot: AbilitySlot):
	if player.health_component.is_dead() or not player.weapon == self: return
	ability_slot.use(global_position, get_attack_location())
