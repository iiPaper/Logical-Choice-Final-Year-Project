extends LogicBase

func _ready():
	super()
	description = "XNOR Gate. Emits a HIGH output when both inputs are the same (both HIGH or both LOW)."
	
func evaluate():
	output = input_a == input_b
