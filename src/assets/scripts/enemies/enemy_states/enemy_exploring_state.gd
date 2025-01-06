extends EnemyState
class_name EnemyExploringState

var player : CharacterBody2D
var move_direction : Vector2
var explore_time : float
var explore_cast : RayCast2D

func enter():
	player = get_tree().get_first_node_in_group("Player")
	explore_cast = RayCast2D.new()
	explore_cast.set_collision_mask_value(1, true)
	enemy.add_child(explore_cast)
	randomize_explore()

func exit():
	explore_cast.queue_free()

func randomize_explore():
	set_explore_direction(Vector2(randf_range(-1,1), randf_range(-1,1)).normalized())

func set_explore_direction(direction):
	move_direction = direction
	explore_cast.target_position = move_direction * 10
	explore_time = randf_range(1,3)

# how could we incorporate watch walls in other states
# without needing to write it in every state
func handle_process(delta: float):
	var wall = explore_cast.get_collider()
	if wall:
		set_explore_direction(move_direction.rotated(deg_to_rad(90)))
	if explore_time > 0:
		explore_time -= delta
	else:
		randomize_explore()

func handle_physics_process(delta: float):
	if !is_instance_valid(enemy): return

	enemy.velocity = move_direction * enemy.data.speed
	if is_instance_valid(player):
		var direction = player.global_position - enemy.global_position
		if direction.length() <= enemy.data.vision_range:
			Transitioned.emit(self, "Engaging")
	else:
		player = get_tree().get_first_node_in_group("Player")
