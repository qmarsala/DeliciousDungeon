class_name AbilityData
extends Resource

@export var has_scene: bool
@export var scene: PackedScene
@export var animation_name: String = "attack"

@export var target_self: bool
@export var ability_sound: AudioStream
@export var cast_time = .3
@export var cooldown = 1.3
@export var damage: float = 1
@export var status_effects: Array[StatusEffect] = []
@export var status_effect_synergy: StatusEffectSynergy

# this feels like its in the wrong spot
@export var input_event = "ability_one"
