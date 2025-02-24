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
@export var lit_lifetime_seconds: float = 30

var lit_at: float = 0

func _ready() -> void:
	interactbox.interacted.connect(interact)
	lit = lit || randf() > 1 - lit_chance
	if lit:
		lit_at = GameTime.time
		animation_player.play(animation_name)

func _process(delta: float) -> void:
	if not lit: 
		return
	
	if GameTime.time - lit_at >= lit_lifetime_seconds:
		lit = false
		animation_player.stop(false)
		animation_player.play("RESET")

func interact(player: Player2) -> void:
	if lit:
		print("open cooking menu")
	else:
		player.light_fire(self)

func light() -> void:
	if lit: return
	lit = true
	audio_stream_player.play()
	animation_player.play(animation_name)
