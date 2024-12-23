extends CharacterBody2D
class_name Enemy

# how to combine these things?
# the scene can't be in the item because of circlular ref
# need some other parent? or just live with it
# probably want a 'enemy data'
@export var drop: Item
@export var pickupScene: PackedScene 
@export var speed: float = 45
@export var drop_rate: float = .3

@onready var random: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var animations: AnimatedSprite2D = $Animations
@onready var attack_range: RayCast2D = %AttackRange
@onready var state_machine: EnemyStateMachine = $StateMachine
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer

var attack_is_cooling_down = false
var agro: float = 0.0

func is_dead(): return %HealthComponent.is_dead()

func receive_damage(damage):
	if is_dead():
		return
	%HealthComponent.take_damage(damage)
	state_machine.transition_to("EnemyFightingState")
	if is_dead():
		var r = random.randf()
		if r <= drop_rate and drop:
			var dropInstance = pickupScene.instantiate()
			dropInstance.item = drop
			dropInstance.position = global_position
			# todo: this needs to stay 'in world' not in root
			# should we signal and have a drop manager?
			# otherwise food doesn't get cleaned up on scene changes
			get_tree().get_first_node_in_group("World").add_child(dropInstance)

func _on_death_timer_timeout():
	queue_free()

func _on_attack_cooldown_timer_timeout():
	attack_is_cooling_down = false
