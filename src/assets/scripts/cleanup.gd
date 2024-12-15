extends Node

func cleanup():
	get_parent().queue_free()
 	
