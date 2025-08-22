extends CharacterBody2D

class_name EnemyBase

@export var value = 1
@export var hp = 1

@onready var sprite_2d = $Sprite2D
@onready var detection_area = $DetectionArea

var is_dead = false
var is_aggressive = false

@onready var effect_player = $EffectPlayer
@onready var invincibility_timer = $InvincibilityTimer

var starting_position
var starting_hp

var player: Player

func _ready():
	# Get the first node from the PLAYER_GROUP, aka the player.
	starting_position = position
	starting_hp = hp
	SignalManager.on_death.connect(on_death)
	SignalManager.on_respawn.connect(on_respawn)
	player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	
func _physics_process(delta):
	pass
	
func take_damage():
	hp -= 1
	
	if hp <= 0:
		die()
		
	else:
		effect_player.play("Hit")
		invincibility_timer.start()
		SignalManager.on_enemy_hit.emit()

func die():
	if is_dead:
		return
		
	is_dead = true
	
	set_physics_process(false)
	hide()
	
	# Other effects
	SignalManager.on_enemy_kill.emit(value)
	SignalManager.on_create_object.emit(Vector2(position.x, position.y - sprite_2d.texture.get_height() / 2), Constants.ObjectType.EXPLOSION)
	SignalManager.on_create_object.emit(Vector2(position.x, position.y - sprite_2d.texture.get_height() / 2), Constants.ObjectType.PICKUP)
	
	queue_free()

func on_death():
	is_aggressive = false
	
func on_respawn():
	if not is_dead:
		position = starting_position
		is_aggressive = false
		hp = starting_hp
		
		for body in detection_area.get_overlapping_bodies():
			if body.is_in_group("Player"):
				is_aggressive = true
				break

func _on_invincibility_timer_timeout():
	effect_player.stop()

func _on_hitbox_area_entered(area):
	take_damage()

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		is_aggressive = true
