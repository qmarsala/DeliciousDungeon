extends EnemyState
class_name EnemyDeadState

@onready var death_timer: Timer = $DeathTimer

func enter():
	SignalBusService.EnemyDied.emit(enemy.data.enemy_id)
	death_timer.start(.7)
	enemy.animations.play("die")

func handle_physics_process(delta: float):
	#is this really how we want to do this?
	enemy.velocity = Vector2(move_toward(enemy.velocity.x, Vector2.ZERO.x, delta), move_toward(enemy.velocity.y, Vector2.ZERO.y, delta))
