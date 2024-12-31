extends Node
class_name Ability

#notes: eventually this class should serve
# as a 'contract' into abilities
# but should be configurable by the abilities themselves.
# for now its a mess of all the things we may need around abilities

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var cast_timer: Timer = $CastTimer

#audio service?
@onready var ability_sound: AudioStreamPlayer = $AbilitySound

var is_on_cooldown = false
var player: Player # todo: not sure I like this, though it is like a component - maybe its ok?
var weapon: Weapon # todo: not sure I like this, though it is like a component - maybe its ok?

var total_cooldown: float = 0

#todo: feels like this should be preconfigured? not injected? /shrug
# this is the 'comonent node' that executes the data, so maybe its ok
var ability_data: AbilityData

func init(p: Player, w: Weapon, data: AbilityData):
	player = p
	weapon = w
	ability_data = data
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

	if event.is_action_pressed(ability_data.input_event) and not is_on_cooldown:
		is_on_cooldown = true
		#ranged poc: the ability should signal and let the weapon do this probably
		if not weapon.use_sprite:
			weapon.animations.play("shoot")
		if ability_data.cast_time > 0:
			#ranged poc:
			cast_timer.start(ability_data.cast_time)
		else:
			use(weapon.get_attack_location())
		cooldown_timer.start(total_cooldown)

func _process(delta: float) -> void:
	if player == null: return
	#ranged poc: probably want to have a setting for 'use charge bar' or something
	# also is this what we want the signal bus for? or should this be a regular signal?
	if !cast_timer.is_stopped() and weapon.weapon_data.item_id == Enums.Items.Staff:
		SignalBusService.AttackCharge.emit(cast_timer.time_left, ability_data.cast_time)

# maybe this could be the attack contract
# melee would swing towards this direction, magic and range shoot toward it
# probably need to start breaking this into sub types of abilities
# like magic/range/melee
func use(target_location):
	if ability_data.scene != null:
		var ability_instance = ability_data.scene.instantiate()
		ability_instance.global_position = target_location
		#ranged poc: need to get something bettew for projectiles
		if ability_instance is Projectile:
			#todo: this should be part of init?
			# abilities that spawn projectiles may be their own class of ability
			ability_instance.damage = ability_data.damage.front()
			ability_instance.max_range = weapon.weapon_data.max_range
			ability_instance.init(ability_data, weapon.global_position, target_location)
		else:
			ability_instance.init(ability_data)
		add_child(ability_instance)
	ability_sound.pitch_scale = randf_range(.95,1.05)
	ability_sound.play()

func _on_cooldown_timer_timeout() -> void:
	is_on_cooldown = false

func _on_cast_timer_timeout() -> void:
	if player.health_component.is_dead() or not player.weapon_equipped: return
	# perhaps we signal the ability and the player calls use if applicable?
	# or player.use(self, weapon)? reason being - we may want to account for
	# player gear/status_effects during the usage?
	use(weapon.get_attack_location())
