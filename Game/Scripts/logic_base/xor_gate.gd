extends LogicBase

func _ready():
	super()
	description = "XOR Gate. Emits a HIGH output when inputs are different (one HIGH, one LOW)."
	
func evaluate():
	output = input_a != input_b
