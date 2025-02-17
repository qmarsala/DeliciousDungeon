extends GameScene

@onready var new_game_label: Label = $NewGameLabel

func _ready():
	super()
	
	if level == 0:
		new_game_label.show()
	else:
		new_game_label.hide()
