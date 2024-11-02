extends Node
class_name Enemy

const STARTING_HP = 5

var health = STARTING_HP

func _process(delta: float) -> void:
	if health <= 0:
		print("dead")
		queue_free()

func receive_damage(damage):
	health -= damage
	print("taking ", damage, " health:", health)
