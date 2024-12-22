extends EnemyState
class_name EnemyFightingState

@export var attack_animation_player: AnimationPlayer
@export var weapon_sprite: Sprite2D
@export var attack_cooldown: float = .8
@export var attack_delay: float = .3
@export var attack_damage = 1.5

@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var attack_timer: Timer = $AttackTimer

var player: CharacterBody2D
var attack_target: Vector2

func enter():
	player = get_tree().get_first_node_in_group("Player")

func handle_process(delta: float):
	if not player or enemy.attack_is_cooling_down: return
	
	var potential_target = player.global_position + (Vector2.UP * 7)
	enemy.melee_range.look_at(potential_target)
	var target = enemy.melee_range.get_collider()
	if target is Hitbox:
		enemy.attack_is_cooling_down = true
		handle_attack_animations()
		attack_target = potential_target
		attack_timer.start(0.3)
		attack_cooldown_timer.start(attack_cooldown)

func handle_physics_process(delta: float):
	if player == null: 
		Transitioned.emit(self, "EnemyExploringState")
		return
	if enemy:
		var direction = player.global_position - enemy.global_position
		var distance = direction.length()
		if distance <= 15:
			enemy.velocity = Vector2.ZERO
		elif distance >= 80:
			Transitioned.emit(self, "EnemyExploringState")
		else:
			enemy.velocity = direction.normalized() * enemy.speed * 1.15

func handle_attack():
	enemy.melee_range.look_at(attack_target)
	var target = enemy.melee_range.get_collider()
	if target is Hitbox:
		target.receive_damage(attack_damage)

func handle_attack_animations():
	if (not (attack_animation_player or weapon_sprite)) or attack_animation_player.is_playing():
		return
	
	var player_width_distance = abs(enemy.global_position.x - player.global_position.x)
	var player_height_distance = enemy.global_position.y - player.global_position.y
	var animation = "swing_east"
	if enemy.global_position.x > player.global_position.x:
		animation = "swing_west"
	if player_height_distance <= -10 and player_width_distance <= 30:
		animation = "swing_south"
	if player_height_distance >= 10 and player_width_distance <= 30:
		animation = "swing_north"
	attack_animation_player.play(animation)


func _on_attack_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name != "RESET":
		attack_animation_player.play("RESET")
