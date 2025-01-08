class_name Hitbox
extends Area2D

@export var health: HealthComponent
@export var status_effects: StatusEffectComponent

# currently these come from the weapon
# wonder what other options there will be?
# a number of things may contribute to armour and evasion?
# or mabye to keep things simple everything is on the weapon?
var armour: float = 0
var evasion: float = 0

func init(health_component: HealthComponent, status_effects_component: StatusEffectComponent):
	health = health_component
	status_effects = status_effects_component

func _ready() -> void:
	add_to_group(Interfaces.Attackable)

func apply_defense_stats(armour: float, evasion: float):
	self.armour = armour
	self.evasion = evasion

func apply_attack(attack: Attack) -> void:
	attack.apply(health, status_effects, armour, evasion)

#poc: passing signals
func connect_weapon_events(weapon_equipped: Signal, weapon_unequipped: Signal) -> void:
	weapon_equipped.connect(on_weapon_equip)
	weapon_unequipped.connect(on_weapon_unequip)

func on_weapon_equip(weapon: Weapon) -> void:
	apply_defense_stats(weapon.weapon_data.armour, weapon.weapon_data.evasion)
	
func on_weapon_unequip() -> void:
	apply_defense_stats(0, 0)
