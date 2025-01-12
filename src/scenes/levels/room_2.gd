class_name Room2
extends Node2D


# perhaps each room once placed can pick the propre tiles set that fits?


func init(id: int, is_start: bool, is_end: bool):
	$Label.hide()
	if is_start:
		$Label.text = "start"
		$Label.show()
	if is_end:
		$Label.text = "end"
		$Label.show()
