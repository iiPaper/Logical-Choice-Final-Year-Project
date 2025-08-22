extends Sprite2D

@export var gate_node_paths: Array[NodePath]
var gate_nodes: Array[Node2D] = []
var node

@export var input_cable: NodePath
var input_node
var input = false

@export var cable_a: NodePath
@export var cable_b: NodePath
@export var cable_c: NodePath
var node_a
var node_b
var node_c

@onready var animation_timer = $AnimationTimer
@onready var animation_player = $AnimationPlayer

@onready var label = $Label

@export var value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("setup")

func setup():
	if input_cable != null:
		input_node = get_node_or_null(input_cable)
	if cable_a != null:
		node_a = get_node_or_null(cable_a)
	if cable_b != null:
		node_b = get_node_or_null(cable_b)
	if cable_c != null:
		node_c = get_node_or_null(cable_c)
	
	for i in range(gate_node_paths.size()):
		gate_nodes.append(get_node(gate_node_paths[i]))
		gate_nodes[i].visible = false
		gate_nodes[i].cable_a = gate_nodes[i].get_path_to(node_a)
		gate_nodes[i].cable_b = gate_nodes[i].get_path_to(node_b)
		gate_nodes[i].cable_c = NodePath("")
		gate_nodes[i].get_nodes()
	
	node = gate_nodes[value]
	node.visible = true
	node.cable_c = node.get_path_to(node_c)
	node.get_nodes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_input = input_node.read()
	
	if current_input and not input:
		print("Here?")
		input = true
		
		animation_player.play("Activating")
		animation_timer.start()
		
		node.visible = false
		node.cable_c = NodePath("")
		node.get_nodes()
	
	elif not current_input and input:
		input = false

func change_gate():
	print("We so here now")
	value = (value + 1) % gate_nodes.size()
	
	node = gate_nodes[value]
		
	node.cable_c = node.get_path_to(node_c)
	node.visible = true
	node.get_nodes()

func _on_animation_timer_timeout():
	print("Hi?")
	change_gate()
