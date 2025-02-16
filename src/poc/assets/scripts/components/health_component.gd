class_name HealthComponent
extends Node

signal HealthDepleted

#todo:wrap in animation controller?
@export var animation_player : AnimationPlayer

# still unsure how I feel about this, maybe it make sense
# that as a component of the character we have access to the character?

# how do we persist this current health in the player/enemy data?
@export var node: Node2D
@export var starting_health : float = 5
@export var signal_damage: bool = true

var health : float = 1

func is_dead() -> bool : 
	return health <= 0

func _ready() -> void:
	if not node:
		node = get_parent()
		if node.has_method("get_data"):
			var data = node.get_data()
			starting_health = data.starting_health
	health = starting_health

# todo: what about armour/effects that reduce damage
# should we have th parent control the final damage somehow?

# health_component should probably just deal with final damage
# we need a component to receieve the attack, apply status effects and armour, 
# then resolve health?

func receive_damage(damage) -> void:
	if is_dead(): return
	if signal_damage:
		SignalBus.DamageReceived.emit(damage, node.global_position, node.is_in_group("Player"))

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
	health = min(health + added_health, starting_health)
