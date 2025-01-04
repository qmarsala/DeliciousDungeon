extends Node
class_name Projectile

# todo: these params need to come from a resource?
# maybe these also live in the parent of the projectile?
@export var speed = 300.0
@export var can_pierce = false
@export var max_pierce_count = 1
@export var max_range = 100
@export var bonus_range = 0 # how do we want to do this? maybe it can just be part of the projectile data? maybe we add this from ability contexts?

var pierce_count = 0
var node: Node2D
var direction: Vector2
var starting_position: Vector2
var target_position: Vector2

# would it make sense to always assume this is a direct child the thing it 'projects'?
func init(target_position: Vector2) -> void:
	self.node = get_parent() as Node2D
	self.starting_position = node.global_position
	self.direction = starting_position.direction_to(target_position)
	self.target_position = direction * max_range * 2
	face_target()

func face_target():
	node.look_at(target_position)
	node.rotate(deg_to_rad(90))

func _physics_process(delta: float) -> void:
	node.global_position += direction * speed * delta
	if node.global_position.distance_to(starting_position) >= max_range + bonus_range:
		node.queue_free()

# what about destroying on contact with environment?
# perhaps this component could have its own env collider to delete on collision with env?
