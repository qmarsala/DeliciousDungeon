extends EnemyState
class_name EnemyStunnedState

# don't disagree that his is a state, but we don't use a state for things like 'bleeding'
# should we?
# do we need concurrent state machines?


var locked_position: Vector2

func enter():
	locked_position = enemy.global_position
	#todo: play stunned animation or something?
func exit():
	pass
	#todo: remove stunned animation/sprite

func handle_process(delta: float):
	if not enemy.status_effects_component.has_effect("stunned"):
		Transitioned.emit(self, "EnemyExploringState")

func handle_physics_process(delta: float):
	if !is_instance_valid(enemy): return
	enemy.velocity = Vector2.ZERO
	enemy.global_position = locked_position
