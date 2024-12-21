extends EnemyState
class_name EnemyFightingState

@export var attack_animation_player: AnimationPlayer
@export var weapon_sprite: Sprite2D
@export var attack_cooldown: float = .8
@export var attack_damage = 1.5

@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer

var player: CharacterBody2D
var time_since_last_attack = 0

func enter():
	player = get_tree().get_first_node_in_group("Player")

func handle_process(delta: float):
	if not player or enemy.attack_is_cooling_down: return
	
	handle_attack_animations()
	enemy.attack_is_cooling_down = true
	attack_cooldown_timer.start(attack_cooldown)
	enemy.melee_range.look_at(player.global_position)
	var target = enemy.melee_range.get_collider()
	if target:
		target.receive_damage(attack_damage)

func handle_physics_process(delta: float):
	if enemy and player:
		var direction = player.global_position - enemy.global_position
		var distance = direction.length()
		if distance <= 15:
			enemy.velocity = Vector2.ZERO
		elif distance >= 80:
			Transitioned.emit(self, "EnemyExploringState")
		else:
			enemy.velocity = direction.normalized() * enemy.speed * 1.15

func handle_attack_animations():
	if not (attack_animation_player or weapon_sprite):
		return
	
	var animation = "swing_east"
	if player.global_position.x - enemy.global_position.x < 0:
		animation = "swing_west"
	if player.global_position.y - enemy.global_position.y > 0 and abs(player.global_position.x - enemy.global_position.x) < 10:
		animation = "swing_south"
	if not attack_animation_player.is_playing():
		attack_animation_player.play(animation)
