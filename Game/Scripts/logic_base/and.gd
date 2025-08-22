extends LogicBase
	
func _ready():
	super()
	description = "AND Gate. Emits a HIGH output only when both inputs are HIGH."
	
func evaluate():
	output = input_a and input_b
