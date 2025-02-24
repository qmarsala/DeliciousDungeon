class_name Fire
extends Node2D

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var unlit: Sprite2D = $Unlit
@onready var lit_animation: AnimatedSprite2D = $LitAnimation
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer
@onready var interactbox: InteractBox = $Interactbox
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

@export var animation_name: String = "campfire_light_flicker"
@export var lit: bool = true
@export var lit_chance: float = .25

func _ready() -> void:
	interactbox.interacted.connect(interact)
	lit = lit || randf() > 1 - lit_chance
	if lit:
		animation_player.play(animation_name)

func interact(player: Player2) -> void:
	if lit:
		print("open cooking menu")
	else:
		light()

func light() -> void:
	if lit: return
	lit = true
	audio_stream_player.play()
	animation_player.play(animation_name)
