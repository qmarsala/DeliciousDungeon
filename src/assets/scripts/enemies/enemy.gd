extends CharacterBody2D
class_name Enemy

@export var data: EnemyData

@onready var random: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var animations: AnimatedSprite2D = $Animations
@onready var attack_range: RayCast2D = %AttackRange
@onready var state_machine: EnemyStateMachine = $StateMachine
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer

# should attack state take care of this?
var attack_is_cooling_down = false
var agro: float = 0.0
var status_effects: Array[StatusEffect]

func _ready() -> void:
	state_machine.init(self)
	%HealthComponent.HealthDepleted.connect(_on_health_depleted)
	add_to_group(Interfaces.HasStatusEffects)

var time: float = 0
func _process(delta: float) -> void:
	time += delta
	var expired_effects = status_effects.filter(func(se: StatusEffect): return se.is_expired(time))
	for ee in expired_effects: 
		status_effects.erase(ee)
	for se in status_effects:
		if se.is_applicable(time):
			se.tick(time)
			receive_damage(se.damage)

func is_dead(): return %HealthComponent.is_dead()

func receive_damage(damage):
	if is_dead(): return
	%HealthComponent.take_damage(damage)
	if is_dead(): return
	state_machine.transition_to("EnemyFightingState")

func has_effect(effect: StatusEffect):
	return status_effects.has(effect)

func apply_effect(effect: StatusEffect):
	if status_effects.has(effect):
		var se_idx = status_effects.find(effect)
		status_effects[se_idx].apply(time)
	else:
		status_effects.append(effect)
		effect.apply(time)

func _on_death_timer_timeout():
	queue_free()

func _on_attack_cooldown_timer_timeout():
	attack_is_cooling_down = false

func _on_health_depleted() -> void:
	state_machine.transition_to("EnemyDeadState")
