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

func _init() -> void:
	add_to_group(Interfaces.Interactable, true)

func _ready() -> void:
	interactbox.interacted.connect(interact)
	if lit:
		animation_player.play(animation_name)
		return
	if !lit and randf() <= lit_chance:
		light()

func interact(player: Player) -> void:
	if lit:
		player.begin_rest()
		return
	
	if player.player_items.has(Enums.Items.Wood) and player.player_items[Enums.Items.Wood] > 0:
		#todo: should we use a signal for this?
		# feels bad mutating the player passed in like this
		player.player_items[Enums.Items.Wood] -= 1
		light()
		player.begin_rest()

func light() -> void:
	if lit: return
	lit = true
	audio_stream_player.play()
	animation_player.play(animation_name)
	#for quest poc - these events could include the player position? that might help with sounds problem?
	SignalBusService.ActionPerformed.emit(Enums.Actions.LightFire)
