extends PlayerState
class_name PlayerIdleState

var idle_at
func enter():
	idle_at = time

func handle_process(delta):
	handle_interact_action()
	if time - idle_at >= 1 and player.weapon_equipped:
		player.weapon.global_position = player.hand.global_position - Vector2(6, 2)
		player.weapon.rotation = 0
