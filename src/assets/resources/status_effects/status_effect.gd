class_name StatusEffect
extends Resource

@export var effect_name: String
@export var blocked_by_effect: StatusEffect
@export var tick_rate: float
@export var total_time: float
@export var damage: float
@export var heal: float
@export var stack_bonus_modifier: float = 0
@export var max_stack_size: int = 3
@export var can_extend: bool = true

# not sure about this - also currently only works on enemies
# some status effects may want to toggle state though
#  we could pass in a new state to state contract that works for enem and player
#  or figure out something else
@export var modifies_state: bool = false
# this also means a state must be implemented for the status
# and only one effect that alters state could be active at any time
@export var new_state: String = "Idle"

var is_applied: bool
var applied_at: float = 0
var last_tick_at: float = 0
var stack_count: float = 1
var tick_count: float = 0

# should apply add itself to the status component, and tick do these things?
func apply(time: float, health_component: HealthComponent, state_machine: StateMachine):
	if not health_component: return
	if not state_machine: return
	if not is_applied:
		applied_at = time
		is_applied = true
	last_tick_at = time
	tick_count += 1
	
	var applied_heal = heal
	var applied_damage = damage
	if stack_bonus_modifier > 0 and stack_count > 1:
		applied_heal += heal * stack_bonus_modifier * stack_count
		applied_damage += damage * stack_bonus_modifier * stack_count
	if applied_heal > 0:
		health_component.heal(applied_heal)
	if applied_damage > 0:
		health_component.receive_damage(applied_damage)
	if modifies_state:
		state_machine.transition_to(new_state)

func extend(time):
	stack_count = clamp(stack_count + 1, 1, max_stack_size)
	if can_extend:
		applied_at = time

func on_expired(status_effect_component: StatusEffectComponent):
	if blocked_by_effect:
		status_effect_component.apply_effect(blocked_by_effect)

func is_applicable(time: float) -> bool:
	return is_applied && time - last_tick_at >= tick_rate and !is_expired(time)

func is_expired(time: float) -> bool:
	return is_applied && time - applied_at >= total_time
