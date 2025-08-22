extends Node2D

class_name LogicBase

@onready var sprite_2d = $Sprite2D

@export var cable_a: NodePath
@export var cable_b: NodePath
@export var cable_c: NodePath

@export var flip = false

@onready var label = $Label

var node_a = null
var node_b = null
var node_c = null

var input_a = false
var input_b = false
var output = false

var description = ""
 
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	get_nodes()
	if flip:
		sprite_2d.flip_h = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	read_inputs()
	evaluate()
	update_sprite()
	set_output()

func get_nodes():
	if cable_a != null:
		node_a = get_node_or_null(cable_a)
	if cable_b != null:
		node_b = get_node_or_null(cable_b)
	if cable_c != null:
		node_c = get_node_or_null(cable_c)

func read_inputs():
	if node_a != null:
		input_a = get_node(cable_a).read()
		
	if node_b != null:
		input_b = get_node(cable_b).read()

func evaluate():
	pass

func update_sprite():
	if output:
		animation_player.play("On")
	else:
		animation_player.play("Off")
		
func set_output():
	if node_c != null:
		node_c.value = output
		node_c.update_color()
