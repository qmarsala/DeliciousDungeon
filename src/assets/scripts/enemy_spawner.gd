class_name EnemySpawner
extends Node2D

@export var enemy_scene: PackedScene

func _ready():
	add_child(enemy_scene.instantiate())
