extends EnemyBase

var value_specific = 2

@export_range(0, 1) var acceleration = 0.05

@onready var floor_detection_ray = $FloorDetectionRay
@onready var far_floor_detection_ray = $FarFloorDetectionRay
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

@export var speed = 175.0

func _ready():
	super._ready()
	value = value_specific
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if sprite.flip_h:
			velocity.x = move_toward(velocity.x, 1 * speed, speed * acceleration)
		else:
		# move_toward: From, To, Delta
			velocity.x = move_toward(velocity.x, -1 * speed, speed * acceleration)
			
	move_and_slide()
	
	#print("player.x:%.2f, robot.x:%.2f, sprite.flip_h:%s" % [player.position.x, position.x, sprite.flip_h])
	if is_on_floor():
		# If robot not aggressive
		if not is_aggressive:
			# Check if a wall has been found or whether there isn't floor beneath
			if is_on_wall() or not floor_detection_ray.is_colliding():
				# In such a case, turn the robot.
				turn()
		# If the robot IS aggressive and the player's y position (+40px)
		# is greater or equal to the robot's y position:
		
		elif is_aggressive and (player.position.y - 40 > position.y):
			# If the player is to the right, and heading right, and has reached the end of a platform
			if player.position.x > position.x and not sprite.flip_h and not floor_detection_ray.is_colliding():
				turn()
				
			# If the player is to the left, and heading right, and has reached the end of a platform.
			elif player.position.x < position.x and sprite.flip_h and not floor_detection_ray.is_colliding():
				turn()
			
			# If you've bumped into a wall, or the far detection ray is not colliding with anything.
			elif is_on_wall() or not far_floor_detection_ray.is_colliding():
				turn()
		
		# Otherwise...
		else:
			# Check whether the robot is running into a wall, or if there is a far away platform
			if is_on_wall() or not floor_detection_ray.is_colliding():
				turn()
				
		# In any other case, the wheelbot will drop down onto the next platform.
	
	update_animations()

func turn():
	#print("Turning")
	velocity.x = 0
	sprite.flip_h = !sprite.flip_h
	floor_detection_ray.position.x = -floor_detection_ray.position.x
	far_floor_detection_ray.position.x = -far_floor_detection_ray.position.x

func update_animations():
	if is_on_floor():
		if is_aggressive:
			if velocity.x == speed or velocity.x == -speed:
				animation_player.play("Run_Aggressive")
			else:
				animation_player.play("Run_Start_Aggressive")
		else:
			if velocity.x == speed or velocity.x == -speed:
				animation_player.play("Run")
			else:
				animation_player.play("Run_Start")
