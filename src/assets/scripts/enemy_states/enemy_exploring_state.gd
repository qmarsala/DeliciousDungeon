extends EnemyState
class_name EnemyExploringState

@export var move_speed := 25

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

func handle_physics_process(delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
	if enemy and player:
		var direction = player.global_position - enemy.global_position
		if direction.length() < 40:
			Transitioned.emit(self, "EnemyFightingState")
