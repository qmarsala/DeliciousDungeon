extends Node2D
class_name Conflagrate

@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#todo: should this go to attack data?
# and how do we want to control what the synergy does?
# maybe it 'pops' the status effect, maybe it doubles our damage?
@export var synergy_effect: StatusEffect

var data: AbilityData

func init(attack_data: AbilityData):
	data = attack_data

func deal_damage(amount):
	var targets = area_2d.get_overlapping_areas()
	for t in targets:
		if t is Hitbox:
			var damage_amount = amount
			if t.node.is_in_group(Interfaces.HasStatusEffects) and t.node.status_effects_component.has_effect(synergy_effect):
				damage_amount *= 2
			t.receive_damage(damage_amount)

func _on_initial_damage_timer_timeout() -> void:
	if data.damage.size() > 0:
		deal_damage(data.damage[0])
	
func _on_mid_damage_timer_timeout() -> void:
	if data.damage.size() > 1:
		deal_damage(data.damage[1])
	elif data.damage.size() > 0:
		deal_damage(data.damage.back())
	
func _on_final_damage_timer_timeout() -> void:
	if data.damage.size() > 2:
		deal_damage(data.damage[2])
	elif data.damage.size() > 0:
		deal_damage(data.damage.back())
	queue_free()
