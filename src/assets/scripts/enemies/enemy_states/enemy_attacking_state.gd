extends EnemyState
class_name EnemyAttackingState

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
var aim_locked: bool
var retreat_cooldown : float = 0.5
var retreated_at : float = 0
var min_retreat_time : float = 0.5

func enter():
	player = get_tree().get_first_node_in_group("Player")
	if not is_instance_valid(player): 
		Transitioned.emit(self, "Idle")
		return

	enemy.velocity = Vector2.ZERO
	initiate_attack()

func initiate_attack():
	if enemy.attack_is_cooling_down: return
	enemy.attack_is_cooling_down = true
	aim_locked = true
	attack_target = player.global_position
	enemy.attack_range.look_at(attack_target)
	handle_attack_animations()
	attack_timer.start(enemy.data.attack_delay)
	attack_cooldown_timer.start(enemy.data.attack_cooldown + enemy.data.attack_delay)

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
	elif distance >= enemy.data.max_distance:
		Transitioned.emit(self, "Exploring")
	else:
		initiate_attack()

# todo: strategy pattern?
# the 'weapon' being the strategy?
func handle_attack():
	aim_locked = false
	if enemy.data.attack_sound and enemy.audio_stream_player and enemy.data.attack_sound_on_delay:
		enemy.audio_stream_player.stream = enemy.data.attack_sound
		# would be nice if this could be handled the same way as in player abilities
		# sound service? also it would be cool if enemies and players used the same 'weapon' objects.
		enemy.audio_stream_player.pitch_scale = randf_range(.95, 1.05)
		enemy.audio_stream_player.play()
	if enemy.data.is_ranged:
		var projectile_instance = enemy.data.attack_scene.instantiate() as Projectile
		var data = AbilityData.new()
		data.damage = enemy.data.attack_damage
		data.targets_enemy = false
		data.targets_player = true
		data.weapon_range = 90
		projectile_instance.init(data, enemy.global_position, attack_target)
		# todo: where is the best place to spawn these things?
		get_tree().root.add_child(projectile_instance)
	else:
		enemy.attack_range.look_at(attack_target)
		var target = enemy.attack_range.get_collider()
		if target is Hitbox:
			var attack = Attack.new()
			attack.damage = enemy.data.attack_damage
			target.apply_attack(attack)

func handle_attack_animations():
	if enemy.data.attack_sound and enemy.audio_stream_player and not enemy.data.attack_sound_on_delay:
		enemy.audio_stream_player.stream = enemy.data.attack_sound
		enemy.audio_stream_player.play()
	#would this also be in the 'weapon'
	if enemy.data.is_ranged:
		if not animated_weapon_sprite or animated_weapon_sprite.is_playing():
			return
		animated_weapon_sprite.play("attack")
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
