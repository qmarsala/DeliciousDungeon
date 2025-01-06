extends EnemyState
class_name EnemyEngageTargetState

var player: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("Player")

func handle_physics_process(delta: float):
	if not is_instance_valid(player):
		Transitioned.emit(self, "Idle")
		return
	
	var direction = enemy.global_position.direction_to(player.global_position)
	var distance = enemy.global_position.distance_to(player.global_position)
	if distance < enemy.data.ideal_distance_min:
		direction *= -1
	
	enemy.velocity = direction.normalized() * enemy.data.speed * enemy.data.engage_speed_multiplier
	if distance >= enemy.data.ideal_distance_min and distance <= enemy.data.ideal_distance_max:
		Transitioned.emit(self, "Attacking")
	elif distance >= enemy.data.max_distance:
		Transitioned.emit(self, "Exploring")
