class_name Fire
extends Node2D

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rest_area: Area2D = $RestArea
@onready var unlit: Sprite2D = $Unlit
@onready var lit_animation: AnimatedSprite2D = $LitAnimation

@export var animation_name: String = "campfire_light_flicker"
@export var lit: bool = true
@export var lit_chance: float = .25

func _ready() -> void:
	rest_area.body_entered.connect(_on_rest_area_body_entered)
	if lit:
		unlit.hide()
		lit_animation.show()
		animation_player.play(animation_name)
		point_light_2d.enabled = true
		return
	if !lit and randf() <= lit_chance:
		lite()

func lite() -> void:
	if lit: return
	lit = true
	lit_animation.show()
	unlit.hide()
	point_light_2d.enabled = true
	animation_player.play(animation_name)

func _on_rest_area_body_entered(body: Node2D) -> void:
	if lit and body is Player:
		body.rest()
