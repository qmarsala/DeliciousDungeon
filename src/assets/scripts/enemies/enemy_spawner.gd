class_name EnemySpawner
extends Node2D

#todo: could be improved
@export var enemy_scene: PackedScene
@export var enemy_scene_b: PackedScene
@export var enemy_scene_b_rate: float = 0.1
@export var no_enemy_rate: float = 0.15

func _ready():
	if randf() <= no_enemy_rate:
		return

	if randf() <= enemy_scene_b_rate:
		var enemy = enemy_scene_b.instantiate() as Enemy
		add_sibling.call_deferred(enemy)
	else:
		var enemy = enemy_scene.instantiate() as Enemy
		add_sibling.call_deferred(enemy)
