extends Node

const CHECKPOINT = "checkpoint"
const COLLECT = "collect"
const DEATH = "death"
const ENEMY_HIT = "enemy_hit"
const ENEMY_JUMP = "enemy_jump"
const ENEMY_SHOOT = "enemy_shoot"
const EXPLOSION = "explosion"
const PLAYER_HIT = "player_hit"
const PLAYER_JUMP = "player_jump"
const PLAYER_SHOOT = "player_shoot"
const TOGGLE = "toggle"


var SOUNDS = {
	CHECKPOINT: preload("res://Sounds/Checkpoint/checkpoint.wav"),
	COLLECT: preload("res://Sounds/Collect/collect.wav"),
	DEATH: preload("res://Sounds/Death/death.wav"),
	ENEMY_HIT: preload("res://Sounds/Enemy_Hit/enemyHit.wav"),
	ENEMY_JUMP: preload("res://Sounds/Enemy_Jump/enemyJump.wav"),
	ENEMY_SHOOT: preload("res://Sounds/Enemy_Shoot/enemyShoot.wav"),
	EXPLOSION: preload("res://Sounds/Explosion/explosion.wav"),
	PLAYER_HIT: preload("res://Sounds/Player_Hit/playerHit.wav"),
	PLAYER_JUMP: preload("res://Sounds/Player_Jump/playerJump.wav"),
	PLAYER_SHOOT: preload("res://Sounds/Player_Shoot/playerShoot.wav"),
	TOGGLE: preload("res://Sounds/Toggle/toggle.wav")
}

func play_sound(player, key):
	if SOUNDS.has(key) == false:
		print("False Sound Play")
		return
		
	else:
		#print("Playing ", key)
		player.stream = SOUNDS[key]
		player.play()
