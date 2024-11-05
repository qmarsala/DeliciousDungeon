extends Node
class_name MeleeAttack

signal melee_attack(attack_type: String)

const BASIC_COOLDOWN = .3
const BASIC_DAMAGE = 1
const HEAVY_COOLDOWN = .7
const HEAVY_DAMAGE = 2.5

@onready var aoe_area: Area2D = $AttackRayCast/AoeArea
@onready var attack_ray_cast: RayCast2D = $AttackRayCast
@onready var cooldown_timer: Timer = $CooldownTimer

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		attack_ray_cast.look_at(event.global_position)

var cooldowns = {"basic_attack": BASIC_COOLDOWN, "heavy_attack": HEAVY_COOLDOWN}
var damages = {"basic_attack": BASIC_DAMAGE, "heavy_attack": HEAVY_DAMAGE}
var attack_is_cooling_down = false

func _process(delta: float) -> void:
	if attack_is_cooling_down:
		return
	var basic_attack_released = Input.is_action_just_released("basic_attack")
	var heavy_attack_released = Input.is_action_just_released("heavy_attack")
	var attack_released = basic_attack_released or heavy_attack_released
	if attack_released:
		melee_attack.emit(get_attack_type(basic_attack_released, heavy_attack_released))

func get_attack_type(basic_attack, heavy_attack) -> String:
	if heavy_attack:
		return "heavy_attack"
	else:
		return "basic_attack"

func swing(attack_type):
	attack_is_cooling_down = true
	cooldown_timer.start(cooldowns[attack_type])
	if attack_type == "heavy_attack" and aoe_area.has_overlapping_bodies():
		var targets = aoe_area.get_overlapping_bodies() 
		for t in targets:
			t.receive_damage(damages[attack_type])
	elif attack_ray_cast.is_colliding():
		var target = attack_ray_cast.get_collider() 
		target.receive_damage(damages[attack_type])

func _on_cooldown_timer_timeout() -> void:
	attack_is_cooling_down = false
