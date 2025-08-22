extends EnemyBase

@export var value_specific = 10
@export var hp_specific = 3

@onready var floor_detection_ray = $FloorDetectionRay
@onready var far_floor_detection_ray = $FarFloorDetectionRay
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var jump_timer = $JumpTimer
@onready var jump_delay_timer = $JumpDelayTimer

var can_jump = true
var jump_started = false
var is_jumping = false

const jump_velocity_left = Vector2(-200.0, -550.0)
const jump_velocity_right = Vector2(200.0, -550.0)

func _ready():
	super._ready()
	starting_hp = hp_specific
	hp = starting_hp
	value = value_specific

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Add the gravity.
	#print("iof: %s, js: %s, ij: %s" % [is_on_floor(), jump_started, is_jumping])
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not is_on_floor() and is_jumping:
		jump_started = true
	
	elif is_on_floor() and jump_started:
		jump_started = false
		is_jumping = false
		velocity.x = 0
	
	jump()
	move_and_slide()
	turn()
	update_animations()

func jump():
	if not (is_on_floor() and can_jump and is_aggressive):
		return
		
	can_jump = false
	is_jumping = true
	
	animation_player.play("Jump")
	
	jump_delay_timer.start()

func turn():
	if (player.position.x > position.x and not sprite.flip_h):
		sprite.flip_h = true
	if (player.position.x < position.x and sprite.flip_h):
		sprite.flip_h = false
	
func update_animations():
	if is_jumping:
		return
		
	if is_on_floor():
		if is_aggressive:
			animation_player.play("Aggressive")
		else:
			animation_player.play("Idle")

func _on_jump_timer_timeout():
	can_jump = true

func _on_jump_delay_timer_timeout():
	SignalManager.on_enemy_jump.emit()
	
	if sprite.flip_h:
		velocity = jump_velocity_right
	else:
		velocity = jump_velocity_left
		
	is_jumping = true
	
	jump_timer.start()

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		is_aggressive = true
		jump_timer.start()

func _on_detection_area_2_body_exited(body):
	if body.is_in_group("Player"):
		is_aggressive = false
