class_name AttackData
extends Resource

@export var scene: PackedScene
@export var charge_time = .25
@export var cooldown = 1.0
@export var attack_action = "basic_attack"
@export var damage: Array[float] = [1]
@export var status_effects: Array[StatusEffect]
