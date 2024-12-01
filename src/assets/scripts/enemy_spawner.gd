class_name EnemySpawner
extends Node2D

@export var enemy_scene: PackedScene

func _ready():
	var enemy = enemy_scene.instantiate() as Enemy
	add_child.call_deferred(enemy)
