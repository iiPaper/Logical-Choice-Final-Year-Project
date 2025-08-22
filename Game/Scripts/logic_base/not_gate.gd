extends LogicBase

func _ready():
	super()
	description = "NOT Gate. Emits the opposite of its SINGLE input. HIGH becomes LOW and vice versa."

func evaluate():
	output = not input_a
	
func update_sprite():
	pass
