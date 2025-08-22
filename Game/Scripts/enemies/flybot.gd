extends EnemyBase

@export var value_specific = 5

@onready var animation_player = $AnimationPlayer
@onready var shooter = $Shooter
@onready var player_detection_ray = $PlayerDetectionRay

@export var velocity_right = Vector2(150,50)
@export var velocity_left = Vector2(-150,50)

var isLowerLimit = false

func _ready():
	super._ready()
	value = value_specific
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_aggressive:
		check_height()
		shoot()
		move_and_slide()
		
	update_animations()

func update_animations():
	if is_aggressive:
		animation_player.play("Aggressive")
	else:
		animation_player.play("Idle")

func check_height():
	if isLowerLimit:
		isLowerLimit = position.y > player.position.y - 175
		velocity.y = -225
		
	else:
		isLowerLimit = position.y > player.position.y + 200
	
func shoot():
	if player_detection_ray.is_colliding():
		shooter.shoot(position.direction_to(player.position))
		SignalManager.on_enemy_shoot.emit()
	

func turn():
	var player_direction = sign(player.position.x - position.x)
	if player_direction > 0:
		velocity = velocity_right
	else:
		velocity = velocity_left
	
func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		is_aggressive = true


func _on_turn_timer_timeout():
	turn()
