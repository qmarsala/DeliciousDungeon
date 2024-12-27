extends PlayerState
class_name PlayerIdleState

var idle_at
func enter():
	idle_at = time

func handle_process(delta):
	super(delta)
	if time - idle_at >= 1 and player.weapon_equipped and player.weapon.sprite:
		player.weapon.sprite.global_position = player.hand.global_position - Vector2(6, 2)
		player.weapon.sprite.rotation = 0
