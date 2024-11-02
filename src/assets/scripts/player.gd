extends CharacterBody2D

const SPEED = 100.0

@onready var character_sprite: AnimatedSprite2D = $CharacterSprite

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("basic_attack"):
		print("basic attack")
	if Input.is_action_just_pressed("heavy_attack"):
		print("heavy attack")

func _physics_process(delta: float) -> void:
	var xDirection = get_x_input()
	var yDirection = get_y_input()
	velocity = calc_player_velocity(xDirection, yDirection)
	play_animation(xDirection, yDirection)
	move_and_slide()

func get_x_input():
	var xDirection := Input.get_axis("move_west", "move_east")
	if xDirection:
		return xDirection
	else:
		return move_toward(velocity.x, 0, SPEED)

func get_y_input():
	var yDirection = Input.get_axis("move_north", "move_south")
	if yDirection:
		return yDirection
	else:
		return move_toward(velocity.y, 0, SPEED)

func calc_player_velocity(xDirection, yDirection):
	return Vector2(xDirection, yDirection).normalized() * SPEED

func play_animation(xDirection, yDirection): 
	if xDirection == 0 and yDirection == 0:
		character_sprite.play("idle")
	else:
		character_sprite.flip_h = xDirection < 0
		character_sprite.play("run")
