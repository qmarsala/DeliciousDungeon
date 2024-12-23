extends PlayerState
class_name PlayerDeadState

@onready var death_timer: Timer = $DeathTimer

func _ready() -> void:
	death_timer.timeout.connect(player.PlayerDied.emit)

func enter() -> void:
	death_timer.start()
	player.character_sprite.play("die")

func handle_physics_process(delta: float) -> void:
	player.velocity = Vector2.ZERO
