extends EnemyState
class_name EnemyFightingState

var attack_is_cooling_down = false
var player: CharacterBody2D
var time_since_last_attack = 0
var cooldown = .8

func enter():
	player = get_tree().get_first_node_in_group("Player")

func handle_process(delta: float):
	if enemy_is_dead(): return
	if attack_is_cooling_down:
		time_since_last_attack += delta
		if time_since_last_attack > cooldown:
			attack_is_cooling_down = false
			time_since_last_attack = 0
	if not player or attack_is_cooling_down: return
	
	enemy.melee_range.look_at(player.global_position)
	var target = enemy.melee_range.get_collider()
	if target:
		attack_is_cooling_down = true
		target.receive_damage(1.5)

func handle_physics_process(delta: float):
	pass
	# if context.player_is_in_range:
	# 	context.velocity = Vector2.ZERO
	# 	return
	# var direction = context.global_position.direction_to(context.target.global_position)
	# context.velocity = direction.normalized() * context.SPEED
	
