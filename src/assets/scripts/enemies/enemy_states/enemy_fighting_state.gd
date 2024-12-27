extends EnemyState
class_name EnemyFightingState

#Notes:
# hacking ranged in here:
# ranged enemies may want their own states?
# the way the want to handle movement and attacking may 
# be different enough from melee?
# if the same states are used, should we use 'strategy' pattern with 'weapons'?


#these two exports need to be consolidated into something
# like an 'animation controller' each weapon may be animated slightly
# differently
@export var attack_animation_player: AnimationPlayer
@export var animated_weapon_sprite: AnimatedSprite2D

# wonder if 'retreat' should be its own state

# maybe need to pull out an audio component
# that reacts to attack events?


@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var attack_timer: Timer = $AttackTimer

var player: CharacterBody2D
var attack_target: Vector2
var target_locked: bool

var retreat_cooldown : float = 0.5
var retreated_at : float = 0
var min_retreat_time : float = 0.5
var time : float = 0
func _process(delta: float) -> void:
	time += delta

func enter():
	player = get_tree().get_first_node_in_group("Player")

func handle_process(delta: float) -> void:
	if not player: return
	# perhaps some angles should cause some skewing / z index changes?
	if not target_locked:
		enemy.attack_range.look_at(player.global_position)
	
	if enemy.attack_is_cooling_down: return
	var potential_target = player.global_position
	enemy.attack_range.look_at(potential_target)
	var target = enemy.attack_range.get_collider()
	if target is Hitbox:
		target_locked = true
		enemy.attack_is_cooling_down = true
		handle_attack_animations()
		attack_target = potential_target
		attack_timer.start(enemy.data.attack_delay)
		attack_cooldown_timer.start(enemy.data.attack_cooldown)

func handle_physics_process(delta: float):
	if player == null: 
		Transitioned.emit(self, "EnemyExploringState")
		return
	if enemy:
		var direction = player.global_position - enemy.global_position
		var distance = direction.length()
		
		if time - retreated_at <= min_retreat_time:
			# todo: what about when this means running into a wall?
			enemy.velocity = -(direction.normalized() * (enemy.data.speed * enemy.data.retreat_speed_multiplier))
			return

		if distance <= enemy.data.min_distance and time - retreated_at >= retreat_cooldown:
			retreated_at = time
		elif distance >= enemy.data.max_distance:
			Transitioned.emit(self, "EnemyExploringState")
		elif distance >= enemy.data.ideal_distance_min and distance <= enemy.data.ideal_distance_max:
			enemy.velocity = Vector2.ZERO
		else:
			enemy.velocity = direction.normalized() * enemy.data.speed * enemy.data.engage_speed_multiplier

# todo: strategy pattern?
# the 'weapon' being the strategy?
func handle_attack():
	if enemy.data.attack_sound and enemy.audio_stream_player and enemy.data.attack_sound_on_delay:
		enemy.audio_stream_player.stream = enemy.data.attack_sound
		enemy.audio_stream_player.play()
	if enemy.data.is_ranged:
		var projectile_instance = enemy.data.projectile.instantiate() as Projectile
		projectile_instance.damage = enemy.data.attack_damage
		projectile_instance.init_old(enemy.global_position, attack_target)
		# todo: where is the best place to spawn these things?
		get_tree().root.add_child(projectile_instance)
	else:
		enemy.attack_range.look_at(attack_target)
		var target = enemy.attack_range.get_collider()
		if target is Hitbox:
			target.receive_damage(enemy.data.attack_damage)
	target_locked = false

func handle_attack_animations():
	if enemy.data.attack_sound and enemy.audio_stream_player and not enemy.data.attack_sound_on_delay:
		enemy.audio_stream_player.stream = enemy.data.attack_sound
		enemy.audio_stream_player.play()
	#would this also be in the 'weapon'
	if enemy.data.is_ranged:
		if not animated_weapon_sprite or animated_weapon_sprite.is_playing():
			return
		animated_weapon_sprite.play("shoot")
	else:
		if (not attack_animation_player) or attack_animation_player.is_playing():
			return
		
		var player_width_distance = abs(enemy.global_position.x - player.global_position.x)
		var player_height_distance = enemy.global_position.y - player.global_position.y
		var animation = "swing_east"
		if enemy.global_position.x > player.global_position.x:
			animation = "swing_west"
		if player_height_distance <= -10 and player_width_distance <= 30:
			animation = "swing_south"
		if player_height_distance >= 10 and player_width_distance <= 30:
			animation = "swing_north"
		attack_animation_player.play(animation)


func _on_attack_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name != "RESET":
		attack_animation_player.play("RESET")
