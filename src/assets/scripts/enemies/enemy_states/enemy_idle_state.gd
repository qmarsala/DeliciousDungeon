extends EnemyState
class_name EnemyIdleState

var idle_at: float
func enter():
	idle_at = time
 
func handle_process(delta: float) -> void:
	if time - idle_at > 3:
		Transitioned.emit(self, "Exploring")
