extends Node2D

@export var player_scene: PackedScene

@export var damage_number: PackedScene

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.PlayerDied.connect(_on_player_died)
	SignalBusService.DamageReceived.connect(_add_damage_number)

func _on_player_died() -> void:
	get_tree().reload_current_scene()

func _add_damage_number(damage: float, position: Vector2, is_target_player: bool):
	var instance = damage_number.instantiate() as DamageNumber
	instance.init(damage, position, is_target_player)
	add_child(instance)
