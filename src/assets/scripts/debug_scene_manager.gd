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

# this should be a component?
func _add_damage_number(damage: float, position: Vector2):
	var instance = damage_number.instantiate() as Label
	instance.text = String.num(damage)
	instance.global_position = position
	add_child(instance)
