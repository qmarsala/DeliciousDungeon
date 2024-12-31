class_name EnemySpawner
extends Node2D

#todo: enemy set like room sets?
@export var enemy_scene: PackedScene
@export var enemy_scene_b: PackedScene
@export var enemy_scene_b_rate: float = 0.1
@export var enemy_scene_c: PackedScene
@export var enemy_scene_c_rate: float = 0.25
@export var no_enemy_rate: float = 0.15

func _ready():
	var seed = randf()
	if seed <= no_enemy_rate:
		return

	var enemy
	var enemy_b = 1 - enemy_scene_b_rate
	var enemy_c = enemy_b - enemy_scene_c_rate
	if seed >= enemy_b:
		enemy = enemy_scene_b.instantiate() as Enemy
	elif seed < enemy_b and seed >= enemy_c:
		enemy = enemy_scene_c.instantiate() as Enemy
	else:
		enemy = enemy_scene.instantiate() as Enemy
	add_child.call_deferred(enemy)
