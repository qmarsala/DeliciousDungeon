class_name Sword
extends Weapon
#TODO: reevaluate the inheritance
# it is mostly to change animation/sprite stuff
# could maybe be handled by an animations component instead

# could we have sprite as a param in weapon data rather than a new scene?
 
@onready var animations: AnimatedSprite2D = $Animations

func _ready():
	if weapon_data.sprite_frames:
		animations.sprite_frames = weapon_data.sprite_frames

var time: float = 0
var animated_at: float = 0
var animating: bool = false
var animation_time: float = .15
func _process(delta):
	super(delta)
	time += delta
	if animating and time - animated_at > animation_time:
		animating = false
		position = Vector2.ZERO
		
func handle_weapon_aim(attack_location: Vector2):
	if attack_location.x > global_position.x:
		animations.rotation_degrees = 80
		animations.flip_h = false
	else:
		animations.rotation_degrees = -80
		animations.flip_h = true

func handle_use_ability_animation(animation_name: String) -> void:
	animations.play(animation_name)
	animating = true
	animated_at = time
	var direction = global_position.direction_to(player.get_global_mouse_position())
	position += direction * 4
