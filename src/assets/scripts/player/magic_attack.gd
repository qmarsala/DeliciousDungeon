extends Node
class_name MagicAttack

signal ranged_attack()
signal ranged_attack_charge(value: float)

#todo: could 'swap' spells from a spell book
@export var spell_data: SpellData
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var cast_timer: Timer = $CastTimer

var is_on_cooldown = false

func _process(delta: float) -> void:
	if Input.is_action_pressed(spell_data.attack_action) and not is_on_cooldown:
		is_on_cooldown = true
		cast_timer.start(spell_data.cast_time)
		cooldown_timer.start(spell_data.cooldown + spell_data.cast_time)

func cast_at_location(target_location):
	#todo: show cast timer
	var spell_instance = spell_data.spell.instantiate() as Spell
	spell_instance.position = target_location
	add_child(spell_instance)

func _on_cooldown_timer_timeout() -> void:
	is_on_cooldown = false

func _on_cast_timer_timeout() -> void:
	cast_timer.stop()
	ranged_attack.emit()
