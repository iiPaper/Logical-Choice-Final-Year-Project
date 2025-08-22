extends Node2D

@onready var level_audio_player = $Player/LevelAudioPlayer
@onready var enemy_action_player = $Player/EnemyActionPlayer
@onready var player_action_player = $Player/PlayerActionPlayer

@onready var main = $"."

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("setup")	
	SignalManager.on_enemy_kill.connect(on_enemy_kill)
	SignalManager.on_coin_collect.connect(on_coin_collect)
	SignalManager.on_death.connect(on_death)
	SignalManager.on_enemy_hit.connect(on_enemy_hit)
	SignalManager.on_toggle.connect(on_toggle)
	#SignalManager.on_player_jump.connect(on_player_jump)
	SignalManager.on_enemy_jump.connect(on_enemy_jump)
	SignalManager.on_enemy_shoot.connect(on_enemy_shoot)
	SignalManager.on_death.connect(on_death)
	
func setup():
	SignalManager.on_level_start.emit()

func _process(delta):
	if Input.is_action_just_pressed("Restart_Level"):
		GameManager.load_level()
	
	if Input.is_action_just_pressed("Next_Level"):
		GameManager.load_next_level()
		
	if Input.is_action_just_pressed("Previous_Level"):
		GameManager.load_previous_level()
		
func update_score(value):
	score += value
	SignalManager.on_score_update.emit(score)
	
func on_toggle():
	SoundManager.play_sound(level_audio_player, SoundManager.TOGGLE)
	
func on_enemy_hit():
	SoundManager.play_sound(enemy_action_player, SoundManager.ENEMY_HIT)
	
func on_enemy_shoot():
	SoundManager.play_sound(enemy_action_player, SoundManager.ENEMY_SHOOT)
	
func on_enemy_jump():
	SoundManager.play_sound(enemy_action_player, SoundManager.ENEMY_JUMP)

func on_enemy_kill(value):
	#SoundManager.play_sound(enemy_action_player, SoundManager.EXPLOSION)
	update_score(value)
	
func on_coin_collect(value):
	SoundManager.play_sound(level_audio_player, SoundManager.COLLECT)
	update_score(value)

#func on_player_jump():
	#SoundManager.play_sound(level_audio_player, SoundManager.PLAYER_JUMP)
	
func on_death():
	SoundManager.play_sound(player_action_player, SoundManager.DEATH)
	update_score(-25)
	
