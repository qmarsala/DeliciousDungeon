extends CharacterBody2D

const SPEED = 200.0

@onready var character_sprite: AnimatedSprite2D = $CharacterSprite

func _physics_process(delta: float) -> void:
	var xDirection := Input.get_axis("move_west", "move_east")
	if xDirection:
		velocity.x = xDirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var yDirection := Input.get_axis("move_north", "move_south")
	if yDirection:
		velocity.y = yDirection * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	play_animation(xDirection, yDirection)
	move_and_slide()

func play_animation(xDirection, yDirection): 
	if xDirection == 0 and yDirection == 0:
		character_sprite.play("idle")
	else:
		character_sprite.flip_h = xDirection < 0
		character_sprite.play("run")
