extends CharacterBody2D

@export var drop_table: ItemDropTable
@export var health: float = 1
@export var speed: float = 30
@export var spawn_chance: float = .75

@onready var health_component: HealthComponent = $HealthComponent

var move_direction: Vector2
var explore_time: float
var idle_time: float
var is_idle: bool
var explore_cast: RayCast2D

func _ready() -> void:
	if randf() < 1 - spawn_chance:
		queue_free()
		return
	
	explore_cast = RayCast2D.new()
	explore_cast.set_collision_mask_value(1, true)
	add_child(explore_cast)
	health_component.HealthDepleted.connect(on_health_depleted)

func _process(delta: float) -> void:
	if is_idle and idle_time > 0:
		idle_time -= delta
	else:
		idle_time = randf_range(2,5)
		is_idle = false
	
	if not is_idle and explore_time > 0:
		explore_time -= delta
		var wall = explore_cast.get_collider()
		if wall:
			set_explore_direction(move_direction.rotated(deg_to_rad(100)))
	else:
		is_idle = true
		explore_time = randf_range(1,3)
		set_explore_direction(Vector2(randf_range(-1,1), randf_range(-1,1)).normalized())

func _physics_process(delta: float) -> void:
	if is_idle: return
	
	velocity = move_direction * speed
	move_and_slide()

func set_explore_direction(dir: Vector2):
	move_direction = dir
	explore_cast.target_position = move_direction * 25

func on_health_depleted() -> void:
	var drop_result = drop_table.get_drop_result()
	ItemDropper.drop_item_stack(drop_result, global_position)
#	todo: use animation to clear
	queue_free()

class BoarHealthData:
	var health: float
	var max_health: float

func get_data() -> BoarHealthData:
	var data = BoarHealthData.new()
	data.health = health
	data.max_health = health
	return data
