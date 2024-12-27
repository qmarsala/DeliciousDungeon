class_name StatusEffect
extends Resource

@export var effect_name: String
@export var tick_rate: float
@export var total_time: float
@export var damage: float

var applied_at: float = 0
var last_tick_at: float = 0

func apply(time: float): 
	applied_at = time

func tick(time: float):
	last_tick_at = time

func is_applicable(time: float):
	return time - last_tick_at >= tick_rate and !is_expired(time)

func is_expired(time: float):
	return time - applied_at >= total_time
