extends CharacterBody2D
class_name Enemy

@export var data: EnemyData

@onready var random: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_range: RayCast2D = %AttackRange
@onready var state_machine: StateMachine = $StateMachine
@onready var status_effects_component: StatusEffectComponent = $StatusEffectsComponent
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox: Hitbox = $Hitbox
@onready var move_component: MovementComponent = $MovementComponent

# should attack state take care of this?
var attack_is_cooling_down = false

func _ready() -> void:
	state_machine.init(self)
	health_component.HealthDepleted.connect(_on_health_depleted)
	status_effects_component.init(health_component, state_machine)
	hitbox.init(health_component, status_effects_component)

func _on_death_timer_timeout():
	queue_free()

func _on_attack_cooldown_timer_timeout():
	attack_is_cooling_down = false

func _on_health_depleted() -> void:
	state_machine.transition_to("Dead")
