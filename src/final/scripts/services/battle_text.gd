class_name BattleTextService
extends Node

#todo: non poc scene
var damage_number_scene: PackedScene = preload("res://poc/scenes/damage_number.tscn")

func _ready() -> void:
	SignalBus.DamageReceived.connect(_add_damage_number)

func _add_damage_number(damage: float, position: Vector2, is_target_player: bool):
	var instance = damage_number_scene.instantiate() as DamageNumber
	instance.init(damage, position, is_target_player)
	add_child(instance)
