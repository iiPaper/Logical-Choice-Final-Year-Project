extends LogicBase
	
func _ready():
	super()
	description = "NAND Gate. Emits a HIGH output unless both inputs are HIGH. It is the inverse of AND."

func evaluate():
	output = not (input_a and input_b)
