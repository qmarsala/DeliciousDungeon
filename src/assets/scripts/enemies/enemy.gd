extends CharacterBody2D
class_name Enemy

const SPEED = 45
const MIN_DISTANCE = 15
const ATTACK_COOLDOWN = 1

# how to combine these things?
# the scene can't be in the item because of circlular ref
# need some other parent? or just live with it
@export var drop: Item
@export var pickupScene: PackedScene 

@onready var random: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var animations: AnimatedSprite2D = $Animations
@onready var melee_range: RayCast2D = $MeleeRange

func is_dead(): return %HealthComponent.is_dead()

func receive_damage(damage):
	%HealthComponent.take_damage(damage)
	if is_dead():
		var r = random.randf()
		if r <= .5 and drop:
			var dropInstance = pickupScene.instantiate()
			dropInstance.item = drop
			dropInstance.position = global_position
			# todo: this needs to stay 'in world' not in root
			# should we signal and have a drop manager?
			# otherwise food doesn't get cleaned up on scene changes
			get_tree().root.add_child(dropInstance)

func _on_death_timer_timeout():
	queue_free()
