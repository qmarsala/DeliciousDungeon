extends PlayerState
class_name PlayerDeadState

@onready var death_timer: Timer = $DeathTimer

func _ready() -> void:
	death_timer.timeout.connect(on_death_timer)

func enter() -> void:
	death_timer.start()
	player.character_sprite.play("die")

func handle_physics_process(delta: float) -> void:
	player.velocity = Vector2.ZERO

func handle_movement_input(input: InputEvent) -> void:
	pass

func on_death_timer():
	player.player_died.emit()
