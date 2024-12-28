extends Node2D
class_name Projectile

# todo: these params need to come from a recourse
@export var speed = 300.0
@export var damage = 2
@export var can_pierce = false
@export var max_pierce_count = 1
@export var max_range = 100
@export var synergy_effect: StatusEffect

var direction = Vector2(0,0)
var target = Vector2(0,0)
var starting_location = Vector2(0,0)
var pierce_count = 0
var data: AbilityData

func _ready() -> void:
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.area_entered.connect(_on_area_2d_area_entered)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	if position.distance_to(starting_location) >= max_range:
		queue_free()

func init(ability_data: AbilityData, starting_position, target_position):
	data = ability_data
	init_old(starting_position, target_position)

func init_old(starting_position, target_position):
	position = starting_position
	starting_location = starting_position
	target = target_position
	direction = global_position.direction_to(target)
	face_target()

# this should just be look at target, 
# not sure why I need the extra rotate
# rotating first in the arrow scene doesn't do anything
func face_target():
	look_at(target)
	rotate(deg_to_rad(90))

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		if area.node.is_in_group(Interfaces.HasStatusEffects):
			if can_pierce:
				area.node.status_effects_component.apply_effect(data.status_effects.front())
			if area.node.status_effects_component.has_effect(synergy_effect):
				area.receive_damage(damage * 2)
			else: 
				area.receive_damage(damage)
		else: 
			area.receive_damage(damage)
	pierce_count += 1
	if can_pierce and pierce_count > max_pierce_count:
		queue_free()
	elif not can_pierce:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(Interfaces.Damageable):
		body.receive_damage(damage)
	queue_free()
