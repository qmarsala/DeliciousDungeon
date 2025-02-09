extends State
class_name StunnedState

# don't disagree that his is a state, but we don't use a state for things like 'bleeding'
# should we?
# do we need concurrent state machines?

var locked_position: Vector2

func enter():
	locked_position = character.global_position
	#todo: play stunned animation or something?
func exit():
	pass
	#todo: remove stunned animation/sprite

# with the more generic state's how can we get typing on these components?
func handle_process(delta: float):
	if not character.status_effects_component:
		Transitioned.emit(self, "Idle")
	if not character.status_effects_component.has_effect("stunned"):
		Transitioned.emit(self, "Exploring")

func handle_physics_process(delta: float):
	if !is_instance_valid(character): return
	character.velocity = Vector2.ZERO
	character.global_position = locked_position
