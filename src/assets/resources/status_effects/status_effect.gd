class_name StatusEffect
extends Resource

@export var effect_name: String
@export var tick_rate: float
@export var total_time: float
@export var damage: float
@export var heal: float
@export var stack_bonus_modifier: float = 0
@export var max_stack_size: int = 3

var is_applied: bool
var applied_at: float = 0
var last_tick_at: float = 0
var stack_count: float = 1
var tick_count: float = 0

func apply(health_component: HealthComponent):
	if not health_component: return
	var applied_heal = heal
	var applied_damage = damage
	if stack_bonus_modifier > 0 and stack_count > 1:
		applied_heal += heal * stack_bonus_modifier * stack_count
		applied_damage += damage * stack_bonus_modifier * stack_count
	if applied_heal > 0:
		health_component.heal(applied_heal)
	if applied_damage > 0:
		health_component.receive_damage(applied_damage)

func extend(time):
	print('extend')
	stack_count = clamp(stack_count + 1, 1, max_stack_size)
	print(stack_count)
	applied_at = time

func tick(time: float): 
	if not is_applied:
		applied_at = time
		is_applied = true
	last_tick_at = time
	tick_count += 1

func is_applicable(time: float) -> bool:
	return is_applied && time - last_tick_at >= tick_rate and !is_expired(time)

func is_expired(time: float) -> bool:
	return is_applied && time - applied_at >= total_time
