extends LogicBase

func _ready():
	super()
	description = "OR Gate. Emits a HIGH output when at least one input is HIGH."

func evaluate():
	output = input_a or input_b
