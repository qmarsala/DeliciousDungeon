extends Node
class_name AbilitySlot

signal use_requested(AbilitySlot)
signal use_pressed(AbilitySlot)

# todo: maybe this could be a slot id and then through settings we can 
# tie slot_id to ability_input_event?
@export var ability_input_event: String

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var cast_timer: Timer = $CastTimer

#audio service?
@onready var ability_sound: AudioStreamPlayer = $AbilitySound

var weapon_data: WeaponData
var ability_data: AbilityData
var ability_scene: PackedScene

var total_cooldown: float = 0
var is_on_cooldown = false

func init(weapon: Weapon, ability: Ability):
	weapon_data = weapon.weapon_data
	ability_scene = ability.scene
	ability_data = ability.data.apply_weapon_stats(weapon_data)
	ability_sound.stream = ability_data.ability_sound
	total_cooldown = ability_data.cooldown + ability_data.cast_time

func _ready() -> void:
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	cast_timer.timeout.connect(_on_cast_timer_timeout)

func _process(delta: float) -> void:
	if !cast_timer.is_stopped() and ability_data.show_castbar:
		SignalBus.Casting.emit(cast_timer.time_left, ability_data.cast_time)

func _unhandled_input(event: InputEvent) -> void:
	if not is_instance_valid(ability_data): return
	if event.is_action_pressed(ability_input_event) and not is_on_cooldown:
		is_on_cooldown = true
		cooldown_timer.start(total_cooldown)
		use_pressed.emit(self)
		if ability_data.cast_time > 0:
			cast_timer.start(ability_data.cast_time)
		else:
			use_requested.emit(self)

func _on_cooldown_timer_timeout() -> void:
	is_on_cooldown = false

func _on_cast_timer_timeout() -> void:
	use_requested.emit(self)

func use_ability(starting_location: Vector2, target_location: Vector2):
	var ability_instance = ability_scene.instantiate() as AbilityScene
	ability_instance.init(ability_data, starting_location, target_location)
	get_tree().root.add_child(ability_instance)
	ability_sound.pitch_scale = randf_range(.95,1.05)
	ability_sound.play()
