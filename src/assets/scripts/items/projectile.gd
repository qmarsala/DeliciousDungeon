extends AbilityScene
class_name Projectile

# redesign notes:
# should projectile be a component that we put in an arrow scene? or spell scene
# the nature of moving and freeing when hitting walls could apply to spells and arrows

var pierce_count = 0

func _ready() -> void:
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.area_entered.connect(_on_area_2d_area_entered)

func _physics_process(delta: float) -> void:
	global_position += direction * data.speed * delta
	if global_position.distance_to(starting_position) >= data.max_range:
		queue_free()

func initialized():
	face_target()

func face_target():
	look_at(target_position)
	rotate(deg_to_rad(90))

# should this be here? - at least some of it should be done by hurtbox
func _on_area_2d_area_entered(area: Area2D) -> void:
	#todo: move hitbox check into hurtbox component
	if area is Hitbox:
		var attack = Attack.new()
		attack.damage = data.damage
		attack.status_effects = data.status_effects
		attack.effect_synergy = data.status_effect_synergy
		area.apply_attack(attack)
	pierce_count += 1
	if data.can_pierce and pierce_count > data.max_pierce_count:
		queue_free()
	elif not data.can_pierce:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
