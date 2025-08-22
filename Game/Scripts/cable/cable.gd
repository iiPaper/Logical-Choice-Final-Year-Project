extends Line2D

@export var value = false

var green = Color.hex(0x61a53fff)
var red = Color.hex(0x962b41ff)

@onready var outline = $Outline

func _ready():
	outline.points = points.duplicate()
	update_color()

func update_color():
	default_color = green if value else red

func read() -> bool:
	return value
