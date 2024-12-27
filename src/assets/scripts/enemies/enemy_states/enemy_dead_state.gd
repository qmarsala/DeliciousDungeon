extends EnemyState
class_name EnemyDeadState

@onready var death_timer: Timer = $DeathTimer


func enter():
	SignalBusService.EnemyDied.emit(enemy.data.enemy_id)
	death_timer.start(.7)
	enemy.animations.play("die")
	var r = enemy.random.randf()
	if r <= enemy.data.drop_rate and enemy.data.drop:
		var dropInstance = enemy.data.pickupScene.instantiate()
		dropInstance.item = enemy.data.drop
		dropInstance.position = enemy.global_position
		# todo: this needs to stay 'in world' not in root
		# should we signal and have a drop manager?
		# otherwise food doesn't get cleaned up on scene changes
		get_tree().get_first_node_in_group("World").add_child(dropInstance)

func handle_physics_process(delta: float):
	enemy.velocity = Vector2(move_toward(enemy.velocity.x, Vector2.ZERO.x, delta), move_toward(enemy.velocity.y, Vector2.ZERO.y, delta))
