extends Node
class_name EnemyState

@export var enemy: Enemy

signal Transitioned
 
func enter():
	pass

func exit():
	pass

func handle_process(delta: float):
	pass
	
func handle_physics_process(delta: float):
	pass

func enemy_is_dead():
	if enemy and enemy.is_dead():
		print(self.name.to_lower())
		Transitioned.emit(self, "EnemyDeadState")
	return enemy.is_dead()
