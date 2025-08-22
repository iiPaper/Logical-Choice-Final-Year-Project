extends StaticBody2D

@export var cable: NodePath
var node

@onready var animation_player = $AnimationPlayer
@onready var collision_shape = $CollisionShape2D
@onready var animation_timer = $AnimationTimer

var is_open = false
var isPlayerInside = false

func _ready():
	if cable != null and has_node(cable):
		node = get_node(cable)
		is_open = node.value
		collision_shape.disabled = is_open

func _process(delta):
	if node and animation_player.current_animation not in ["Activating", "Deactivating"]:
		if node.value and not is_open:
			animation_player.play("Activating")
			animation_timer.start()
		elif not node.value and is_open and not isPlayerInside:
			animation_player.play("Deactivating")
			collision_shape.disabled = false
			animation_timer.start()

func _on_animation_timer_timeout():
	if animation_player.current_animation == "Activating":
		animation_player.play("On")
		is_open = true
		collision_shape.disabled = true
	
	if animation_player.current_animation == "Deactivating":
		animation_player.play("Off")
		is_open = false

func _on_area_2d_body_entered(body):
	isPlayerInside = true

func _on_area_2d_body_exited(body):
	isPlayerInside = false
