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

var health = STARTING_HP
var is_dead = false
var player_is_visible = false
var player

var explore_direction = Vector2(randf_range(-1,1), randf_range(-1,1))
var is_exploring = false

func _process(delta: float) -> void:
	if is_dead: return
	if health <= 0:
		animations.play("die")
		death_timer.start(.75)
		is_dead = true
		return
	if not animations.is_playing():
		animations.play("idle")
	if player_is_visible:
		attack()

func _physics_process(delta: float) -> void:
	if is_dead: return
	if player_is_visible:
		var distance = global_position.distance_to(player.global_position)
		if distance <= MIN_DISTANCE: return
		var direction = global_position.direction_to(player.global_position)
		velocity = direction.normalized() * SPEED
	else:
		velocity = explore_direction.normalized() * (SPEED / 2)
	move_and_slide()

var attack_is_cooling_down = false
func attack():
	if attack_is_cooling_down or not player_is_visible:
		return
	cooldown_timer.start(ATTACK_COOLDOWN)
	attack_is_cooling_down = true
	melee_range.look_at(player.global_position)
	var target = melee_range.get_collider()
	if target:
		target.receive_damage(1.5)

func receive_damage(damage):
	if is_dead: return 

	animations.play("receive_damage")
	health -= damage
	print("taking ", damage, " health:", health)

func _on_timer_timeout() -> void:
	var t = Vector2(randf_range(-1,1), randf_range(-1,1))
	print("picking new target", t)
	explore_direction = t

func _on_vison_area_body_entered(body: Node2D) -> void:
	player_is_visible = true
	player = body
	print("see player")

func _on_vison_area_body_exited(body: Node2D) -> void:
	player_is_visible = false
	print("player is gone")

func _on_cooldown_timer_timeout() -> void:
	attack_is_cooling_down = false

func _on_death_timer_timeout() -> void:
	queue_free()
