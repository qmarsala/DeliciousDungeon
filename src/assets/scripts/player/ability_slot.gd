extends Node
class_name AbilitySlot

signal use_requested(AbilitySlot)
signal use_pressed(AbilitySlot)

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var cast_timer: Timer = $CastTimer

#audio service?
@onready var ability_sound: AudioStreamPlayer = $AbilitySound

var is_on_cooldown = false
var player: Player # todo: not sure I like this, though it is like a component - maybe its ok?
var weapon: Weapon # todo: not sure I like this, though it is like a component - maybe its ok?

var total_cooldown: float = 0

var ability_input_event: String
var ability_data: AbilityData
var ability_scene: PackedScene

func init(player: Player, weapon: Weapon, ability: Ability):
	self.player = player
	self.weapon = weapon
	ability_scene = ability.scene
	ability_data = ability.data
	ability_input_event = ability.input_event
	ability_sound.stream = ability_data.ability_sound
	total_cooldown = (ability_data.cooldown + ability_data.cast_time) - ability_data.cooldown * weapon.weapon_data.cooldown_reduction

func _ready() -> void:
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	cast_timer.timeout.connect(_on_cast_timer_timeout)

# should this signal, and perhaps the player ultimately 'uses' the ability?
func _unhandled_input(event: InputEvent) -> void:
	# might want the weapon to listen, how will we prevent casting two attacks at once?
	# do we want to prevent that though? its fun
	if not (is_instance_valid(player) and is_instance_valid(ability_data)): return
	if player.health_component.is_dead() or not player.weapon_equipped: return

	if event.is_action_pressed(ability_input_event) and not is_on_cooldown:
		is_on_cooldown = true
		cooldown_timer.start(total_cooldown)
		use_pressed.emit(self)
		if ability_data.cast_time > 0:
			cast_timer.start(ability_data.cast_time)
		else:
			use_requested.emit(self)

func _process(delta: float) -> void:
	if player == null: return
	#ranged poc: probably want to have a setting for 'use charge bar' or something
	# also is this what we want the signal bus for? or should this be a regular signal?
	if !cast_timer.is_stopped() and weapon.weapon_data.item_id == Enums.Items.Staff:
		SignalBusService.AttackCharge.emit(cast_timer.time_left, ability_data.cast_time)

func use(starting_location: Vector2, target_location: Vector2):
	var ability_instance = ability_scene.instantiate() as AbilityScene
	ability_instance.init(ability_data, starting_location, target_location)
	#maybe this whole method is a weapon operation?
	# ability slot should just be about hanlding input in relation to cooldowns
	get_tree().root.add_child(ability_instance)
	ability_sound.pitch_scale = randf_range(.95,1.05)
	ability_sound.play()

func _on_cooldown_timer_timeout() -> void:
	is_on_cooldown = false

func _on_cast_timer_timeout() -> void:
	use_requested.emit(self)
