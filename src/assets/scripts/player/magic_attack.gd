extends Node
class_name MagicAttack

@export var attack_data: AttackData
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var cast_timer: Timer = $CastTimer

var is_on_cooldown = false
var player: Player # todo: not sure I like this, though it is like a component - maybe its ok?
var weapon: Weapon # todo: not sure I like this, though it is like a component - maybe its ok?


func init(p: Player, w: Weapon):
	player = p
	weapon = w

func _unhandled_input(event: InputEvent) -> void:
	# might want the weapon to listen, how will we prevent casting two attacks at once?
	if player == null or player.is_dead() or not player.weapon_equipped: return
	if event.is_action_pressed(attack_data.attack_action) and not is_on_cooldown:
		is_on_cooldown = true
		if attack_data.charge_time > 0:
			cast_timer.start(attack_data.charge_time)
		else:
			attack(weapon.get_attack_location())
		cooldown_timer.start(attack_data.cooldown + attack_data.charge_time)

func _process(delta: float) -> void:
	if player == null: return
	if !cast_timer.is_stopped():
		SignalBusService.AttackCharge.emit(cast_timer.time_left, attack_data.charge_time)

# maybe this could be the attack contract
# melee would swing towards this direction, magic and range shoot toward it
func attack(target_location):
	if attack_data.scene != null:
		var attack_instance = attack_data.scene.instantiate()
		attack_instance.global_position = target_location
		attack_instance.init(attack_data)
		add_child(attack_instance)
		#$PlayerSpellSound.play()

func _on_cooldown_timer_timeout() -> void:
	is_on_cooldown = false

func _on_cast_timer_timeout() -> void:
	cast_timer.stop()
	if player.is_dead() or not player.weapon_equipped: return
	attack(weapon.get_attack_location())
