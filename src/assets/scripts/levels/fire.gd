class_name Fire
extends Node2D

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rest_area: Area2D = $RestArea
@onready var unlit: Sprite2D = $Unlit
@onready var lit_animation: AnimatedSprite2D = $LitAnimation
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer
@onready var interactbox: InteractBox = $Interactbox

@export var animation_name: String = "campfire_light_flicker"
@export var lit: bool = true
@export var lit_chance: float = .25

func _init() -> void:
	add_to_group(Interfaces.Interactable, true)

func _ready() -> void:
	interactbox.interacted.connect(interact)
	rest_area.body_entered.connect(_on_rest_area_body_entered)
	if lit:
		unlit.hide()
		lit_animation.show()
		animation_player.play(animation_name)
		point_light_2d.enabled = true
		return
	if !lit and randf() <= lit_chance:
		light()

func interact(player: Player) -> void:
	if player.player_items.has(Enums.Items.Wood) and player.player_items[Enums.Items.Wood] > 0:
		#todo: should we use a signal for this?
		# feels bad mutating the player passed in like this
		player.player_items[Enums.Items.Wood] -= 1
		player.rest()
		audio_stream_player.play()
		light()
		#for quest poc - these events could include the player position? that might help with sounds problem?
		SignalBusService.ActionPerformed.emit(Enums.Actions.LightFire)

func light() -> void:
	if lit: return
	lit = true
	lit_animation.show()
	unlit.hide()
	point_light_2d.enabled = true
	animation_player.play(animation_name)

func _on_rest_area_body_entered(body: Node2D) -> void:
	if lit and body is Player:
		body.rest()
