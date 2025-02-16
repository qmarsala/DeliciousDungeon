extends PlayerState
class_name PlayerRestingState

var rested_at: float
var rest_time: float = 3
var rest_completed: bool = false

var cancel: bool = false

func enter():
	if player.rest_is_cooldown:
		Transitioned.emit(self, "Idle")
		return
	player.velocity = Vector2.ZERO
	rest_completed = false
	cancel = false
	rested_at = time
	if player.weapon_equipped:
		player.weapon.hide()

func handle_process(delta):
	player.velocity = Vector2.ZERO
	var elapsed = time - rested_at
	SignalBus.Resting.emit(rest_time - elapsed, rest_time)
	rest_completed = time - rested_at >= rest_time
	if rest_completed:
		Transitioned.emit(self, "Idle")
#
func handle_interact_action(event: InputEvent):
	pass
#
func handle_movement_input(event: InputEvent):
	if event.is_action_pressed("move"):
		if not cancel:
			cancel = true
		else:
			Transitioned.emit(self, "Move")

func exit():
	SignalBus.Resting.emit(0, rest_time)
	if rest_completed:
		player.complete_rest()
	if player.weapon_equipped:
		player.weapon.show()
