extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var checkpoint = $"."
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var sprite_2d = $Sprite2D

var is_activated = false

func _on_body_entered(body):
	if is_activated:
		return
	
	SignalManager.on_checkpoint_hit.emit(Vector2(position.x, position.y + sprite_2d.texture.get_height()))
	SignalManager.on_hp_update.emit(5)
	animation_player.play("Activation")
	checkpoint.set_deferred("monitoring", false)
	is_activated = true
	
	SoundManager.play_sound(audio_stream_player_2d, "checkpoint")
