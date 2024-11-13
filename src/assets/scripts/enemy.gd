extends CharacterBody2D
class_name Enemy

const STARTING_HP = 5
const SPEED = 100.0
const MIN_DISTANCE = 15
const ATTACK_COOLDOWN = 1

@onready var animations: AnimatedSprite2D = $Animations
@onready var death_timer: Timer = $DeathTimer
@onready var timer: Timer = $Timer
@onready var melee_range: RayCast2D = $MeleeRange
@onready var cooldown_timer: Timer = $CooldownTimer

@onready var idle_state: EnemyState = $IdleState
@onready var exploring_state: EnemyState = $ExploringState
@onready var fighting_state: EnemyState = $FightingState
@onready var dead_state: EnemyState = $DeadState
@onready var goblin_state: EnemyState = $IdleState
@onready var explore_ray_cast: RayCast2D = $ExploreRayCast


var health = STARTING_HP
var is_dead = false
var player_is_visible = false
var player_is_in_range = false
var attack_is_cooling_down = false
var is_exploring = false
var explore_direction = Vector2(randf_range(-1,1), randf_range(-1,1))
var target

func _process(delta: float) -> void:
	if health <= 0:
		goblin_state = dead_state
	elif player_is_visible:
		goblin_state = fighting_state
	elif is_exploring:
		goblin_state = exploring_state
	else:
		goblin_state = idle_state
	goblin_state.handle_process(self, delta)

func play_animation():
	if velocity == Vector2.ZERO:
		animations.play("idle")
	else:
		animations.play("run")

func _physics_process(delta: float) -> void:
	goblin_state.handle_physics_process(self, delta)
	animations.flip_h = velocity.x < 0
	move_and_slide()

func receive_damage(damage):
	if is_dead: return
	animations.stop()
	animations.play("receive_damage")
	health -= damage
	print("taking ", damage, " health:", health)

func _on_timer_timeout() -> void:
	is_exploring = randf() <= .5
	var t = Vector2(randf_range(-1,1), randf_range(-1,1))
	explore_direction = t

func _on_vison_area_body_entered(body: Node2D) -> void:
	player_is_visible = true
	target = body
	print("see player")

func _on_vison_area_body_exited(body: Node2D) -> void:
	player_is_visible = false
	print("player is gone")

func _on_cooldown_timer_timeout() -> void:
	attack_is_cooling_down = false

func _on_death_timer_timeout() -> void:
	queue_free()

func _on_personal_space_body_entered(body: Node2D) -> void:
	player_is_in_range = true

func _on_personal_space_body_exited(body: Node2D) -> void:
	player_is_in_range = false
