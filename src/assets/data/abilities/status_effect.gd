class_name StatusEffect
extends Resource

@export var effect_name: String
@export var tick_rate: float
@export var total_time: float
@export var damage: float

var applied_at: float = 0
var last_tick_at: float = 0

func apply(time: float): 
	last_tick_at = time
	applied_at = time

func tick(time: float):
	last_tick_at = time

func is_applicable(time: float):
	return time - last_tick_at >= tick_rate and !is_expired(time)

func is_expired(time: float):
	return time - applied_at >= total_time

func pop(time: float) -> float:
	if is_expired(time): return 0
	var elappesd = time - applied_at
	var time_left = total_time - elappesd
	var ticks_left = time_left / tick_rate
	return damage * ceil(ticks_left)
	
