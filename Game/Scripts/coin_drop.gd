extends RigidBody2D

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var collection_area = $CollectionArea
@onready var collect_timer = $CollectTimer

const VALUE = 3
const INITIAL_BOOST = 350.0

var is_collected = false

func _ready():
	# Give it an initial upward boost
	apply_central_impulse(Vector2.UP * INITIAL_BOOST)

func despawn():
	hide()
	queue_free()

func _on_despawn_timer_timeout():
	despawn()

func _on_collection_area_body_entered(body):

	SignalManager.on_coin_collect.emit(VALUE)
	set_deferred("collection_area.monitoring", false)
	animation_player.play("Collect")
	collect_timer.start()
	
	is_collected = true

func _on_collect_timer_timeout():
	despawn()
