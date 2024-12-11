extends PlayerState
class_name PlayerDeadState

var died_at : float = 0
var signaled_death : bool 
func enter() -> void:
	died_at = time
	player.death_timer.start(.7)
	player.character_sprite.play("die")

func handle_physics_process(delta: float) -> void:
	player.velocity = Vector2(move_toward(player.velocity.x, Vector2.ZERO.x, delta), move_toward(player.velocity.y, Vector2.ZERO.y, delta))

func handle_process(delta: float) -> void:
	if time - died_at >= .7 and not signaled_death:
		signaled_death = true
		player.PlayerDied.emit()
	
func handle_interact_action() -> void:
	pass
func handle_movement_input(delta: float) -> void:
	pass
func handle_dash_input() -> void:
	pass
