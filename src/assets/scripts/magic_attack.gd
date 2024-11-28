extends Node
class_name MagicAttack

signal ranged_attack()
signal ranged_attack_charge(value: float)

@export var spell: PackedScene
@export var charge_time = .5
@export var cooldown = 0.0
@export var attack_action = "heavy_attack"

@onready var cooldown_timer: Timer = $CooldownTimer

var can_charge = true
var is_on_cooldown = false

var basic_pressed_time : float = 0.0 : 
	get:
		return basic_pressed_time
	set(v):
		if basic_pressed_time != v and basic_pressed_time >= charge_time * .25:
			ranged_attack_charge.emit((v / charge_time) * 100)
		basic_pressed_time = v

func _process(delta: float) -> void:
	if Input.is_action_pressed(attack_action) and not is_on_cooldown:
		is_on_cooldown = true
		cooldown_timer.start(cooldown)
		ranged_attack.emit()
	#if not Input.is_action_pressed(attack_action):
		#basic_pressed_time = 0
		#can_charge = true
	#if Input.is_action_pressed(attack_action) and can_charge and not is_on_cooldown:
		#basic_pressed_time += delta
	#if basic_pressed_time >= charge_time:
		#can_charge = false
		#is_on_cooldown = true
		#cooldown_timer.start(cooldown)
		#ranged_attack.emit()
		#basic_pressed_time = 0

func cast_at_location(target_location):
	print("cast")
	var spell_instance = spell.instantiate() as Spell
	spell_instance.position = target_location
	add_child(spell_instance)

func _on_cooldown_timer_timeout() -> void:
	is_on_cooldown = false
