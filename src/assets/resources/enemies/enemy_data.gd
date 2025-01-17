class_name EnemyData
extends Resource

#if we are spawning enemies
# would it make sense to have an enemy scene in the data, and we 
# give the spawnenrs the enemy data to work with?

@export var enemy_id: Enums.Enemies = Enums.Enemies.Goblin
@export var name: String = "Goblin"
@export var starting_health: float = 5
@export var speed: float = 40
@export var vision_range: float = 80
@export var engage_speed_multiplier: float = 1.25
@export var retreat_speed_multiplier: float =  0.75

# need a drop table probably
@export var drop_rate: float = .334
@export var drop: Item

@export var min_distance = 10
#is ideal_distance_min/max really 'attack range'?
# could we calculate this from ability range?
@export var ideal_distance_min = 11
@export var ideal_distance_max = 19
@export var max_distance = 80
@export var idle_at_distance = 256

@export var ability: Ability 
