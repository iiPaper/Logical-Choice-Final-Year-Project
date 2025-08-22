extends Control

@onready var score_counter = $MarginContainer/HBoxContainer/ScoreCounter
@onready var hp_container = $MarginContainer/HBoxContainer/HPContainer
@onready var blinds = $Blinds
@onready var completion_container = $Blinds/CompletionContainer
@onready var death_container = $Blinds/DeathContainer
@onready var death_instruction = $Blinds/DeathContainer/Instruction

@onready var animation_player = $AnimationPlayer

@onready var fade_timer = $FadeTimer
@onready var appear_timer = $AppearTimer

const HEART = preload("res://Sprites/Other/Heart/heart.png")
const HEART_EMPTY = preload("res://Sprites/Other/Heart/heart_empty.png")

var hp_array
var is_dead = false
var is_complete = false


var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	hp_array = hp_container.get_children()
	SignalManager.on_hp_update.connect(on_hp_update)
	SignalManager.on_score_update.connect(on_score_update)
	SignalManager.on_completion.connect(on_completion)
	SignalManager.on_level_start.connect(on_level_start)
	
func _process(delta):
	if Input.is_action_just_pressed("Jump") and is_complete:
		completion_container.visible = false
		animation_player.play("Vanish")
		fade_timer.start()
		
			
	if is_dead:
		death_instruction.text = "Respawning in %.2f..." % player.respawn_timer.time_left
		
func on_hp_update(hp):
	if is_dead:
		if hp > 0:
			on_respawn()
	
	for slot in range(hp_array.size()):
		hp_array[slot].texture = (HEART if hp > slot else HEART_EMPTY)
		
	if hp <= 0:
		on_death()

func on_death():
	is_dead = true
	blinds.self_modulate = Color("39393988")
	blinds.visible = true
	death_container.visible = true
	
func on_respawn():
	is_dead = false
	blinds.self_modulate = Color("393939ff")
	blinds.visible = false
	death_container.visible = false

func on_completion():
	is_complete = true
	blinds.self_modulate = Color("39393988")
	blinds.visible = true
	completion_container.visible = true
	
func on_level_start():
	blinds.self_modulate = Color("393939ff")
	blinds.visible = true
	animation_player.play("Appear")
	appear_timer.start()

func on_score_update(score):
	score_counter.text = str(score)

func _on_fade_timer_timeout():
	GameManager.load_next_level()

func _on_appear_timer_timeout():
	blinds.visible = false
	animation_player.stop()
