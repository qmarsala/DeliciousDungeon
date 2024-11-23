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

func play_animation():
	if velocity == Vector2.ZERO:
		animations.play("idle")
	else:
		animations.play("run")

func _physics_process(delta: float) -> void:
	move_and_slide()

	if velocity.length() > 0:
		animations.play("run")
	animations.flip_h = velocity.x > 0

func receive_damage(damage):
	if is_dead: return
	animations.stop()
	animations.play("receive_damage")
	health -= damage
	print("taking ", damage, " health:", health)


func _on_death_timer_timeout() -> void:
	queue_free()

func _on_cooldown_timer_timeout() -> void:
	attack_is_cooling_down = false
