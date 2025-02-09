extends EnemyState
class_name EnemyIdleState
 
var player: Player
func enter():
	player = get_tree().get_first_node_in_group("Player")

func handle_process(delta: float) -> void:
	if not is_instance_valid(enemy):
		return 
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Player")
		return

	if enemy.global_position.distance_to(player.global_position) < enemy.data.idle_at_distance:
		Transitioned.emit(self, "Exploring")
