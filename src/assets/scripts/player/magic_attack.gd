extends Node
class_name MagicAttack

signal attack()
signal attack_charge(value: float)

#todo: could 'swap' spells from a spell book
@export var spell_data: SpellData
@export var player: Player # todo: not sure I like this, though it is like a component - maybe its ok?
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var cast_timer: Timer = $CastTimer

var is_on_cooldown = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(spell_data.attack_action) and not is_on_cooldown:
		is_on_cooldown = true
		cast_timer.start(spell_data.cast_time)
		cooldown_timer.start(spell_data.cooldown + spell_data.cast_time)

func _process(delta: float) -> void:
	if not player.weapon_equipped:
		$MagicAttackIndicator.hide()
	else:
		$MagicAttackIndicator.show()
		$MagicAttackIndicator.global_position = get_magic_attack_location()

func cast_at_location(target_location):
	#todo: show cast timer
	var spell_instance = spell_data.spell.instantiate() as Spell
	spell_instance.global_position = target_location
	#todo: how to play this at a spot? seems to get weird when inside our non node2d
	# maybe sound service can handle that? also only needed if we want things to react 
	# to sound with a listener
	$PlayerSpellSound.play()
	add_child(spell_instance)

func _on_cooldown_timer_timeout() -> void:
	is_on_cooldown = false

func _on_cast_timer_timeout() -> void:
	cast_timer.stop()
	if player.is_dead() or not player.weapon_equipped: return
	cast_at_location(get_magic_attack_location())

func get_magic_attack_location() -> Vector2:
	var mouse_pos = player.get_global_mouse_position()
	var direction = mouse_pos - player.global_position
	var target_location = mouse_pos
	if direction.length() > 75:
		target_location = player.global_position + (direction.normalized() * 75)
	return target_location
