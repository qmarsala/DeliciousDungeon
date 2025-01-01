extends Area2D

func _ready() -> void:
	var children = get_children()
	for c in children: 
		if c is TriggerStrategy:
			body_entered.connect(c.execute)
