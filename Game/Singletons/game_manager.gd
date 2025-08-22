extends Node

const MAIN = preload("res://Scenes/level_base/level_0.tscn")
const LEVEL_AMOUNT = 11

var levels = {}
var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_completion.connect(on_completion)
	for level in range(LEVEL_AMOUNT):
		levels[level] = load("res://Scenes/level_base/level_%d.tscn" % level)

func load_level():
	get_tree().change_scene_to_packed(levels[current_level])
	
	
func reload_level():
	levels[current_level] = load("res://Scenes/level_base/level_%d.tscn" % current_level)
	load_level()
	
func load_next_level():
	current_level += 1
	if current_level >= LEVEL_AMOUNT:
		current_level = 0
	load_level()
		
func load_previous_level():
	current_level -= 1
	if current_level < 0:
		current_level = LEVEL_AMOUNT - 1
	load_level()
	
func on_completion():
	for moveable in get_tree().get_nodes_in_group("Moveables"):
		moveable.set_physics_process(false)
