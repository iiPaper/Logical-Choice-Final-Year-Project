extends Area2D

class_name Bullet

var bullet_direction: Vector2 = Vector2.RIGHT
var bullet_lifespan: float = 3.0
var bullet_lifetime: float = 0.0

func _process(delta):
	position += bullet_direction * delta
	check_lifetime(delta)

func check_lifetime(delta):
	bullet_lifetime += delta
	if bullet_lifetime >= bullet_lifespan:
		#print("Lifetime exceeded lifespan")
		queue_free()

func setup(pos: Vector2, direction: Vector2, speed: float, lifespan: float):
	bullet_direction = direction.normalized() * speed
	bullet_lifespan = lifespan
	global_position = pos
	
func _on_area_entered(area):
	queue_free()

func _on_body_entered(body):
	queue_free()
