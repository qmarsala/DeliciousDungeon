extends Area2D

@export var scene: Enums.Scenes = Enums.Scenes.Dungeon
@export var is_dungeon_floor_completion: bool

func _ready() -> void:
	body_entered.connect(handle_body_entered)

func handle_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		SceneChangeRequestedEvent.create(scene, is_dungeon_floor_completion).emit()
