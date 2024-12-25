class_name EnemyData
extends Resource

#if we are spawning enemies
# would it make sense to have an enemy scene in the data, and we 
# give the spawnenrs the enemy data to work with?

@export var enemy_id: Enums.Enemies = Enums.Enemies.Goblin
@export var name: String = "Goblin"
@export var starting_health: float = 5
@export var speed: float = 40
@export var vision_range: float = 70
@export var engage_speed_multiplier: float = 1.15
@export var retreat_speed_multiplier: float =  0.7
@export var drop_rate: float = .3
@export var drop: Item
# what can we do here? I could see that maybe we would want a 
# custom pickup area and therefor have a different pickup scene to 
# use for a certain item. So is this ok?
# it cant live in item due to circlular ref.
# probably would just like it to somehow live with item
# maybe we need an item and item data?
# item can include a scene and pickup scense plus its data?
@export var pickupScene: PackedScene 

@export var min_distance = 10
#is ideal_distance_min/max really 'attack range'?
@export var ideal_distance_min = 11
@export var ideal_distance_max = 19
@export var max_distance = 80

# combat stuff - does some of this go to an attack_data and we can make 
# different types of attacks to share across enemies?
@export var attack_cooldown: float = .8
@export var attack_delay: float = .3
@export var attack_damage: float = 1
@export var is_ranged: bool = false
@export var projectile: PackedScene
@export var attack_sound: AudioStream
@export var attack_sound_on_delay: bool = false
