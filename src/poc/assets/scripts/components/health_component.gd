class_name HealthComponent
extends Node

signal HealthDepleted

#todo:wrap in animation controller?
@export var animation_player : AnimationPlayer
@export var signal_damage: bool = true

@onready var node: Node2D = get_parent()

var max_health: float = 3
var health: float = 1

func is_dead() -> bool : 
	return health <= 0

func _ready() -> void:
	if not node:
		node = get_parent()
		if node.has_method("get_data"):
			var data = node.get_data()
			health = data.health
			max_health = data.max_health

func receive_damage(damage) -> void:
	if is_dead(): return
	if signal_damage:
		var event = DamageReceivedEvent.create(damage, node.global_position, node.is_in_group("Player"))
		event.emit()

	health -= damage
	# maybe this can be moved to an animations controller that listens for a signal?
	if animation_player\
		and animation_player.has_animation("receive_damage")\
		and !(animation_player.is_playing() and animation_player.current_animation == "dash"):
		animation_player.play("receive_damage")
	if is_dead():
		HealthDepleted.emit()
		if animation_player and animation_player.has_animation("die"):
			animation_player.play("die")

func heal(added_health) -> void:
	if is_dead(): return
	health = min(health + added_health, max_health)
