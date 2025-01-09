extends EnemyState
class_name EnemyAttackingState

#these two exports need to be consolidated into something
# like an 'animation controller' each weapon may be animated slightly
# differently
@export var animated_weapon_sprite: AnimatedSprite2D

@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var attack_timer: Timer = $AttackTimer

var player: CharacterBody2D
var attack_target: Vector2
var aim_locked: bool
var retreat_cooldown : float = 0.5
var retreated_at : float = 0
var min_retreat_time : float = 0.5
var attacked_at: float
var min_attack_time: float = 0.5

func enter():
	player = get_tree().get_first_node_in_group("Player")
	if not is_instance_valid(player): 
		Transitioned.emit(self, "Idle")
		return
	initiate_attack()

func initiate_attack():
	if enemy.attack_is_cooling_down: return
	enemy.velocity = Vector2.ZERO
	enemy.attack_is_cooling_down = true
	aim_locked = true
	attack_target = player.global_position
	enemy.attack_range.look_at(attack_target)
	handle_attack_animations()
	attack_timer.start(enemy.data.ability.data.cast_time)
	attack_cooldown_timer.start(enemy.data.ability.data.cooldown + enemy.data.ability.data.cast_time)
	attacked_at = time

func handle_physics_process(delta: float):
	if not is_instance_valid(player): 
		Transitioned.emit(self, "Idle")
		return
	
	if not aim_locked:
		enemy.attack_range.look_at(player.global_position)
	var direction = player.global_position - enemy.global_position
	var distance = direction.length()
	if (distance <= enemy.data.ideal_distance_min and time - retreated_at >= retreat_cooldown) or distance <= enemy.data.min_distance:
		retreated_at = time
		Transitioned.emit(self, "Repositioning")
	elif distance > enemy.data.ideal_distance_max and time - attacked_at >= min_attack_time:
		Transitioned.emit(self, "Engaging")
	elif distance >= enemy.data.max_distance:
		Transitioned.emit(self, "Exploring")
	else:
		initiate_attack()

func handle_attack():
	aim_locked = false
	# the sound stuff should probably happen in the ability scene? though they don't live long
	# so we would need to change how that works to do that?
	# todo: animation player for this?
	enemy.audio_stream_player.stream = enemy.data.ability.data.ability_sound
	enemy.audio_stream_player.pitch_scale = randf_range(.95, 1.05)
	enemy.audio_stream_player.play()
	var ability_scene = enemy.data.ability.scene.instantiate() as AbilityScene
	var start = enemy.global_position + (enemy.global_position.direction_to(attack_target) * 8)
	ability_scene.init(enemy.data.ability.data, start, attack_target)
	ability_scene.apply_scale(enemy.scale)
	get_tree().root.add_child(ability_scene)

# ability has an animation name - but the troll has more complex animations
# we do need to abstract this part a bit, but how will we deal with the variations
# in animations?
func handle_attack_animations():
	if animated_weapon_sprite and not animated_weapon_sprite.is_playing():
		animated_weapon_sprite.play("attack")
	elif enemy.animation_player:
		var animation = "attack"
		if enemy.data.enemy_id == Enums.Enemies.Troll:
			#todo: animation player and animation tree
			var player_width_distance = abs(enemy.global_position.x - player.global_position.x)
			var player_height_distance = enemy.global_position.y - player.global_position.y
			animation = "swing_east"
			if enemy.global_position.x > player.global_position.x:
				animation = "swing_west"
			if player_height_distance <= -10 and player_width_distance <= 30:
				animation = "swing_south"
			if player_height_distance >= 10 and player_width_distance <= 30:
				animation = "swing_north"
		if enemy.animation_player.is_playing() and enemy.animation_player.current_animation == animation:
			return
		enemy.animation_player.play(animation)
