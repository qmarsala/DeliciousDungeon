class_name Potion
extends Sprite2D

@export var data: PotionData

func use_data(data: PotionData):
	self.data = data
	texture = data.sprite
