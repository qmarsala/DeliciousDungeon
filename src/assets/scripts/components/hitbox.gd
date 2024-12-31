class_name Hitbox
extends Area2D

@export var health: HealthComponent
@export var status_effects: StatusEffectComponent

func init(health_component: HealthComponent, status_effects_component: StatusEffectComponent):
	health = health_component
	status_effects = status_effects_component

func _ready() -> void:
	add_to_group(Interfaces.Attackable)

func apply_attack(attack: Attack) -> void:
	attack.apply(health, status_effects)
