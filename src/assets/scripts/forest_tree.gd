class_name ForestTree
extends StaticBody2D

@export var felled_tree_top: PackedScene

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var health_component: HealthComponent = $HealthComponent

func chop():
	if health_component.is_dead(): return
	
	health_component.take_damage(1)
	if health_component.is_dead():
		var rect = sprite_2d.region_rect
		sprite_2d.rotation_degrees = 0
		sprite_2d.region_rect = Rect2(rect.position.x, rect.position.y + 15, rect.size.x, rect.size.y - 14)
		sprite_2d.global_position = Vector2(sprite_2d.global_position.x, sprite_2d.global_position.y + 8)
		
		if felled_tree_top:
			var instance = felled_tree_top.instantiate() as Node2D
			add_child.call_deferred(instance)
