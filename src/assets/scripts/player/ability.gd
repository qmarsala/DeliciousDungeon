extends Node
class_name Ability

@export var ability_data: AbilityData

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var cast_timer: Timer = $CastTimer
@onready var ability_sound: AudioStreamPlayer = $AbilitySound


var is_on_cooldown = false
var player: Player # todo: not sure I like this, though it is like a component - maybe its ok?
var weapon: Weapon # todo: not sure I like this, though it is like a component - maybe its ok?

func init(p: Player, w: Weapon):
	player = p
	weapon = w

func _ready() -> void:
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	cast_timer.timeout.connect(_on_cast_timer_timeout)

func _unhandled_input(event: InputEvent) -> void:
	# might want the weapon to listen, how will we prevent casting two attacks at once?
	if player == null or player.is_dead() or not player.weapon_equipped: return
	if event.is_action_pressed(ability_data.input_event) and not is_on_cooldown:
		is_on_cooldown = true
		if ability_data.cast_time > 0:
			cast_timer.start(ability_data.cast_time)
		else:
			attack(weapon.get_attack_location())
		cooldown_timer.start(ability_data.cooldown + ability_data.cast_time)

func _process(delta: float) -> void:
	if player == null: return
	if !cast_timer.is_stopped():
		SignalBusService.AttackCharge.emit(cast_timer.time_left, ability_data.cast_time)

# maybe this could be the attack contract
# melee would swing towards this direction, magic and range shoot toward it
func attack(target_location):
	if ability_data.scene != null:
		var ability_instance = ability_data.scene.instantiate()
		ability_instance.global_position = target_location
		ability_instance.init(ability_data)
		add_child(ability_instance)
	ability_sound.play()

func _on_cooldown_timer_timeout() -> void:
	is_on_cooldown = false

func _on_cast_timer_timeout() -> void:
	if player.is_dead() or not player.weapon_equipped: return
	attack(weapon.get_attack_location())
