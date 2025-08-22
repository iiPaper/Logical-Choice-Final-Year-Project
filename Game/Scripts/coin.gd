extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var coin = $"."
@onready var collect_timer = $CollectTimer

const VALUE = 3

var is_collected

func _on_body_entered(body):
	if is_collected:
		return
	
	SignalManager.on_coin_collect.emit(VALUE)
	set_deferred("monitoring", false)
	animation_player.play("Collect")
	collect_timer.start()
	
	is_collected = true

func _on_collect_timer_timeout():
	hide()
	queue_free()
