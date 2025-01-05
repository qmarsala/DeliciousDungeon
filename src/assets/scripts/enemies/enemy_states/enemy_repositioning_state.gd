extends EnemyState
class_name EnemyRepositioningState

@onready var reposition_cooldown: Timer = $RepositionCooldown

var player: CharacterBody2D
var direction: Vector2
var max_time: float = 1
var cooldown: float = .5
var entered_at: float
func enter():
	if reposition_cooldown.time_left > 0:
		Transitioned.emit(self, "Attacking")
		return
	entered_at = time
	player = get_tree().get_first_node_in_group("Player")

func exit():
	reposition_cooldown.start(cooldown)

func handle_physics_process(delta: float):
	if reposition_cooldown.time_left > 0:
		return
		
	if not is_instance_valid(player):
		Transitioned.emit(self, "Idle")
		return

	direction = player.global_position - enemy.global_position
	enemy.velocity = -(direction.normalized() * (enemy.data.speed * enemy.data.retreat_speed_multiplier))
	var distance = direction.length()
	if (distance >= enemy.data.ideal_distance_min and distance <= enemy.data.ideal_distance_max) or time - entered_at > max_time:
		Transitioned.emit(self, "Attacking")
	elif distance > enemy.data.ideal_distance_max and distance < enemy.data.max_distance:
		Transitioned.emit(self, "Engaging")
	elif distance >= enemy.data.max_distance:
		Transitioned.emit(self, "Exploring")
