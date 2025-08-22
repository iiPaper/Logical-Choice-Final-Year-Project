extends Node2D

const OBJECT_SCENES: Dictionary = {
	#Constants.ObjectType.EXPLODE: ,
	Constants.ObjectType.PICKUP: preload("res://Scenes/coins/coin_drop.tscn"),
	Constants.ObjectType.BULLET_PLAYER: preload("res://Scenes/bullets/bullet_player.tscn"),
	Constants.ObjectType.BULLET_ENEMY: preload("res://Scenes/bullets/bullet_enemy.tscn"),
	Constants.ObjectType.EXPLOSION: preload("res://Scenes/explosion/explosion.tscn")
}

func _ready():
	SignalManager.on_create_bullet.connect(on_create_bullet)
	SignalManager.on_create_object.connect(on_create_object)
	
func on_create_bullet(pos: Vector2, direction: Vector2, speed: float, lifespan: float, object_type: Constants.ObjectType) -> void:
	if not OBJECT_SCENES.has(object_type):
		return
	var new_bullet: Bullet = OBJECT_SCENES[object_type].instantiate()
	new_bullet.setup(pos, direction, speed, lifespan)
	call_deferred("add_child", new_bullet)

func on_create_object(pos: Vector2, object_type: Constants.ObjectType) -> void:
	if not OBJECT_SCENES.has(object_type):
		return
	var new_object = OBJECT_SCENES[object_type].instantiate()
	new_object.position = pos
	call_deferred("add_child", new_object)
