class_name Level
extends Node2D

signal ChangeLevel

@export var end_trigger: Area2D

func _ready() -> void:
	if end_trigger:
		end_trigger.body_entered.connect(change_level)

func add_end_trigger(trigger: Area2D):
	end_trigger = trigger
	end_trigger.body_entered.connect(change_level)

func change_level(body: Node2D):
	if body.is_in_group("Player"):
		ChangeLevel.emit()
