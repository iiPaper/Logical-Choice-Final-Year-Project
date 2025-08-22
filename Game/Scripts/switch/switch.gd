extends Area2D

@export var is_useless = false
var is_activatable = false
var is_on_cooldown = false
var is_signalling = false

@export var cable: NodePath
var node

@onready var signal_timer = $SignalTimer
@onready var cooldown_timer = $CooldownTimer
@onready var animation_player = $AnimationPlayer

@onready var label = $Label

@export var output = false

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("setup")

func setup():
	label.visible = false
	if output:
		animation_player.play("On")
	else:
		animation_player.play("Off")
		
	if cable != null and has_node(cable):
		node = get_node(cable)
		node.value = output
		node.update_color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_useless:
		#print("is_activatable: %s, is_on_cooldown: %s, is_signalling: %s" % [is_activatable, is_on_cooldown, is_signalling])
		if is_activatable and not (is_on_cooldown or is_signalling):
			if Input.is_action_just_pressed("Interact"):
				if output:
					animation_player.play("On-To-Off")
				else:
					animation_player.play("Off-To-On")
				
				SignalManager.on_toggle.emit()
				
				is_signalling = true
				signal_timer.start()
				
				label.visible = false
				
				is_on_cooldown = true
				cooldown_timer.start()

func _on_body_entered(body):
	if not is_useless:
		is_activatable = true
		if not is_on_cooldown:
			label.visible = true

func _on_body_exited(body):
	if not is_useless:
		is_activatable = false
		label.visible = false

func _on_cooldown_timer_timeout():
	is_on_cooldown = false
	if is_activatable:
		label.visible = true

func _on_signal_timer_timeout():
	is_signalling = false
	output = not output
	
	if node != null:
		node.value = output
		node.update_color()
