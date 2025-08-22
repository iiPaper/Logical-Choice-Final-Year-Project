extends Area2D

@export var is_useless = false
var is_activatable = false
var is_on_cooldown = false
var is_signalling = false

@export var gate_node_paths: Array[NodePath]
var gate_nodes: Array[Node2D] = []
var node

@export var secondary_switch: NodePath
@export var secondary_cable: NodePath

@export var output_cable: NodePath
var output_node

@onready var signal_timer = $SignalTimer
@onready var cooldown_timer = $CooldownTimer
@onready var animation_player = $AnimationPlayer

@onready var label = $Label

@export var tutorial_label_path: NodePath
var tutorial_label_node

@export var value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("setup")

func setup():
	output_node = get_node(output_cable)
	tutorial_label_node = get_node(tutorial_label_path)
	
	for i in range(gate_node_paths.size()):
		gate_nodes.append(get_node(gate_node_paths[i]))
		gate_nodes[i].visible = false
		gate_nodes[i].cable_c = NodePath("")
		gate_nodes[i].get_nodes()
	
	node = gate_nodes[value]
	node.visible = true
	node.cable_c = node.get_path_to(output_node)
	node.get_nodes()
	tutorial_label_node.text = node.description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_useless:
		if is_activatable and not (is_on_cooldown or is_signalling):
			if Input.is_action_just_pressed("Interact"):
				animation_player.play("Activating")
				
				SignalManager.on_toggle.emit()
				
				is_signalling = true
				signal_timer.start()
				
				label.visible = false
				
				is_on_cooldown = true
				cooldown_timer.start()

func change_tutorial():
	node.visible = false
	node.cable_c = NodePath("")
	node.get_nodes()
	
	value = (value + 1) % gate_nodes.size()
	
	node = gate_nodes[value]
	
	if node.description.begins_with("NOT Gate."):
		get_node(secondary_switch).visible = false
		get_node(secondary_cable).visible = false
		
	else:
		get_node(secondary_switch).visible = true
		get_node(secondary_cable).visible = true
		
	node.cable_c = node.get_path_to(output_node)
	node.visible = true
	node.get_nodes()
	tutorial_label_node.text = node.description
	
	
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
	change_tutorial()
