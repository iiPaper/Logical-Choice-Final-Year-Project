extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_text("Level %d - FPS %d" % [GameManager.current_level + 1, Engine.get_frames_per_second()])
