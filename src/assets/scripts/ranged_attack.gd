extends Node
class_name RangedAttack

signal ranged_attack()
signal ranged_attack_charge(value: float)

@export var arrow: PackedScene

const CHARGED_ATTACK_TIME = .5
const CHARGED_COOLDOWN = 0

var can_charge = true

var basic_pressed_time : float = 0.0 : 
	get:
		return basic_pressed_time
	set(v):
		basic_pressed_time = v
		ranged_attack_charge.emit(basic_pressed_time)

func _process(delta: float) -> void:
	if not Input.is_action_pressed("basic_attack"):
		basic_pressed_time = 0
		can_charge = true
	if Input.is_action_pressed("basic_attack") and can_charge:
		basic_pressed_time += delta
	if basic_pressed_time >= CHARGED_ATTACK_TIME:
		can_charge = false
		ranged_attack.emit()
		basic_pressed_time = 0

#todo: maybe the arrow should come from the character
func shoot_arrow(starting_position, target):
	var arrow_instance = arrow.instantiate() as Arrow
	arrow_instance.init(starting_position, target)
	add_child(arrow_instance)
	
