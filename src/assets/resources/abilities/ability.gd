class_name Ability
extends Resource

# idea: could we use an id and use that for ability binding and look up the scene and data
# from an ability registry? 
# 1XX melee, 2XX, magic, 3XX range?
@export var ability_id: int

@export var scene: PackedScene
@export var data: AbilityData
