extends AbilityScene
class_name Projectile

# redesign notes:
# - how does this fit into 'ability'
# - how can enemy/player bow/spells benefit from projectile?
# maybe projectile should actually be a component that we put in an arrow scene?

# todo: these params need to come from a recourse
@export var speed = 300.0
@export var can_pierce = false
@export var max_pierce_count = 1
@export var max_range = 100
@export var bonus_range = 0 # how do we want to do this? maybe it can just be part of the projectile data? maybe we add this from ability contexts?

var pierce_count = 0

func _ready() -> void:
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.area_entered.connect(_on_area_2d_area_entered)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	if global_position.distance_to(starting_position) >= max_range + bonus_range:
		queue_free()

func init_old(starting_position: Vector2, target_position: Vector2):
	self.starting_position = starting_position
	self.target_position = target_position
	initialized()

func initialized():
	face_target()

func face_target():
	look_at(target_position)
	rotate(deg_to_rad(90))

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var attack = Attack.new()
		attack.damage = data.damage
		attack.status_effects = data.status_effects
		attack.effect_synergy = data.status_effect_synergy
		area.apply_attack(attack)
	pierce_count += 1
	if can_pierce and pierce_count > max_pierce_count:
		queue_free()
	elif not can_pierce:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
