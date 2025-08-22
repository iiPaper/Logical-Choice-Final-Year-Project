extends LogicBase

func _ready():
	super()
	description = "NOR Gate. Emits a HIGH output only when both inputs are LOW. It is the inverse of OR."
	
func evaluate():
	output = not (input_a or input_b)
