extends CharacterBody2D

class_name Player

const STARTING_HP = 5
@export var hp = 5

@export var walk_speed = 250.0
@export var run_speed = 350.0
@export_range(0, 1) var acceleration = 0.1 
@export_range(0, 1) var deceleration = 0.1

@export var jump_force = -600.0
@export_range(0,1) var decelerate_on_jump_release = 0.25

@export var dash_speed = 1000.0
@export var dash_max_distance = 300.0
@export var dash_curve: Curve
@export var dash_cooldown = 3

@onready var hitbox = $Hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_sprite: Sprite2D = $Sprite2D
@onready var debug_label = $DebugLabel
@onready var shooter: Shooter = $Shooter
@onready var effect_animation_player = $EffectAnimationPlayer
@onready var invincibility_timer = $Timers/InvincibilityTimer
@onready var damaged_timer = $Timers/DamagedTimer
@onready var respawn_timer = $Timers/RespawnTimer
@onready var dash_timer = $Timers/DashTimer
@onready var coyote_timer = $Timers/CoyoteTimer

const LOWER_THRESHOLD = 1250

var is_running = false
var is_dashing = false
var is_shooting = false
var is_invincible = false
var is_damaged = false
var is_dead = false
var can_jump = true
var dash_start_position = 0
var dash_direction = 0
var shoot_time = 0

var speed = 0
var direction = 0

var spawnpoint

func _ready():
	call_deferred("setup")
	
func setup():
	SignalManager.on_hp_update.emit(hp)
	SignalManager.on_checkpoint_hit.connect(on_checkpoint_hit)
	spawnpoint = position
	
func _physics_process(delta):
	if is_dead:
		pass
		
	else:
		check_oob()
		# Add the gravity.
		if not is_on_floor():
			if can_jump and coyote_timer.is_stopped():
				coyote_timer.start()
				
			velocity += get_gravity() * delta
		
		else:
			can_jump = true
			if coyote_timer.time_left > 0:
				coyote_timer.stop()

		
		if not is_damaged:
			# Handle jump.
			if Input.is_action_just_pressed("Jump") and can_jump:
				velocity.y = jump_force
				SignalManager.on_player_jump.emit()
			
			if Input.is_action_just_released("Jump") and velocity.y < 0:
				velocity.y *= decelerate_on_jump_release
			
			if velocity.y >= 500:
				velocity.y = 500
			
			is_running = Input.is_action_pressed("Run")
			if is_running:
				speed = run_speed
			else:
				speed = walk_speed

			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			direction = Input.get_axis("Left", "Right")
			if direction:
				player_sprite.flip_h = (direction == -1)
				velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
			else:
				# move_toward: From, To, Delta
				velocity.x = move_toward(velocity.x, 0, speed * deceleration)
				
			
			# Dash Section
			## Dash Activation
			if Input.is_action_just_pressed("Dash") and direction and not is_dashing and dash_timer.is_stopped():
				is_dashing = true
				dash_start_position = position.x
				dash_direction = direction
				dash_timer.start()
				
			## Dash Execution
			if is_dashing:
				var current_distance = abs(position.x - dash_start_position)
				if current_distance >= dash_max_distance or is_on_wall():
					is_dashing = false
				else:
					velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance / dash_max_distance)
					velocity.y = 0
				
			# Shoot Section
			## Shoot Activation
			if Input.is_action_just_pressed("Shoot") and not is_shooting and not is_dashing:
				is_shooting = shoot()
				shoot_time = Time.get_unix_time_from_system()
				
			## Stop Shooting Animation
			if is_shooting and Time.get_unix_time_from_system() > shoot_time + .4:
				is_shooting = false
		
		move_and_slide()
		update_animations()
		#update_debug_label()

func shoot():
	var result
	if player_sprite.flip_h:
		result = shooter.shoot(Vector2.LEFT)
	else:
		result = shooter.shoot(Vector2.RIGHT)
	return result

func take_damage(damage = 1):
	if is_invincible or is_dead:
		return
	
	else:
		is_dashing = false
		
		# Process Damage/Remove HP
		hp -= damage
		if hp <= 0:
			SignalManager.on_death.emit()
			on_death()
		
		SignalManager.on_hp_update.emit(hp)
		
		# Invincibility
		on_invincible()
		
		# Damage Knockback
		is_damaged = true
		velocity = Vector2(-100 * direction, -350)
		damaged_timer.start()
		

func on_death():
	is_dead = true
	visible = false
	hitbox.monitoring = false
	hitbox.monitorable = false
	respawn_timer.start()
	
func on_respawn():
	is_dead = false
	visible = true
	hitbox.monitoring = true
	hitbox.monitorable = true
	hp = STARTING_HP
	SignalManager.on_hp_update.emit(hp)
	SignalManager.on_respawn.emit()
	position = spawnpoint
	velocity = Vector2(0, 0)
	on_invincible()
	
func on_invincible():
	is_invincible = true
	invincibility_timer.start()
	effect_animation_player.play("Invincible")

func on_checkpoint_hit(checkpoint_position):
	hp = STARTING_HP
	spawnpoint = Vector2(checkpoint_position.x, checkpoint_position.y)

# Check whether the player is out-of-bounds. Kill if so.
func check_oob():
	if position.y > LOWER_THRESHOLD:
		take_damage(hp)
	
# Update the AnimationPlayer.
func update_animations():
	if is_dashing:
			animation_player.play("Dash")
	
	elif is_shooting:
		animation_player.play("Shoot")
	
	elif is_on_floor():
		if direction == 0:
			animation_player.play("Idle")
		
		elif is_running:
			animation_player.play("Run")
		else:
			animation_player.play("Walk")
		
	else:
		if velocity.y > 0:
			animation_player.play("Fall")
		if velocity.y < 0:
			animation_player.play("Jump")

# Update the debug label information.
func update_debug_label():
	debug_label.text = "floor:%s\nisInv:%s\n%.0f,%0.f\nx:%.0f,y:%.0f\n%s" % [ is_on_floor(), is_invincible, velocity.x, velocity.y, position.x, position.y, animation_player.current_animation]

# When the invincibility timer runs out, make the player vincible again.
func _on_invincibility_timer_timeout():
	is_invincible = false
	effect_animation_player.stop()

# On an object entering the player's hitbox, deal damage to the player.
func _on_hitbox_area_entered(_area):
	take_damage()
	
# When the damage taken timer runs out, reset the flag. (Allowing the player to continue actions)
func _on_damage_timer_timeout():
	is_damaged = false

# When the respawn timer runs out, respawn the player.
func _on_respawn_timer_timeout():
	on_respawn()


func _on_dash_timer_timeout():
	is_dashing = false
	effect_animation_player.play("Dash_Recharged")
	

func _on_coyote_timer_timeout():
	can_jump = false
