extends EnemyState
class_name EnemyExploringState

var player : CharacterBody2D
var move_direction : Vector2
var explore_time : float

func randomize_explore():
	move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	explore_time = randf_range(1,3)

func enter():
	player = get_tree().get_first_node_in_group("Player")
	randomize_explore()

func handle_process(delta: float):
	if explore_time > 0:
		explore_time -= delta
	else:
		randomize_explore()

#test: is_instance_valid vs != null?
func handle_physics_process(delta: float):
	if is_instance_valid(enemy):
		enemy.velocity = move_direction * enemy.data.speed
		if is_instance_valid(player):
			var direction = player.global_position - enemy.global_position
			if direction.length() <= enemy.data.vision_range:
				Transitioned.emit(self, "EnemyFightingState")
		else:
			#todo: why do we need this? the first 'state enter' isn't setting it correctly for some reason
			player = get_tree().get_first_node_in_group("Player")
