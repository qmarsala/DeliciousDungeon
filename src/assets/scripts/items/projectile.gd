extends AbilityScene
class_name Projectile

# redesign notes:
# should projectile be a component that we put in an arrow scene? or spell scene
# the nature of moving and freeing when hitting walls could apply to spells and arrows

@onready var hurtbox: Hurtbox = $Hurtbox

var pierce_count = 0

func _ready() -> void:
	var attack = Attack.new()
	attack.damage = data.damage
	attack.status_effects = data.status_effects
	attack.effect_synergy = data.status_effect_synergy
	hurtbox.init(attack, data.targets_player, data.targets_enemy, true)
	hurtbox.set_collision_mask_value(1, true)
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	hurtbox.body_entered.connect(_on_hurtbox_body_entered)

func _physics_process(delta: float) -> void:
	global_position += direction * data.speed * delta
	if global_position.distance_to(starting_position) > data.max_range:
		queue_free.call_deferred()

func initialized():
	face_target()

func face_target():
	look_at(target_position)
	rotate(deg_to_rad(90))

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		pierce_count += 1
		if data.can_pierce and pierce_count > data.max_pierce_count:
			queue_free.call_deferred()
		elif not data.can_pierce:
			queue_free.call_deferred()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	queue_free.call_deferred()
