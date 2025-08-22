extends Node2D

class_name Shooter

@onready var timer: Timer = $Timer
@onready var sound: AudioStreamPlayer2D = $Sound

@export var speed: float = 500.0
@export var lifespan: float = 3.0
@export var bullet_key: Constants.ObjectType
@export var delay: float = .67

var delay_down: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = delay

func shoot(direction):
	if not delay_down:
		return false
		
	delay_down = false
	
	SignalManager.on_create_bullet.emit(global_position, direction, speed, lifespan, bullet_key)

	timer.start()
	return true

func _on_timer_timeout():
	delay_down = true
