extends CanvasLayer

var is_paused : bool = false;

func _process(delta : float) -> void:
	if (Input.is_action_just_pressed("Escape")):
		is_paused = !is_paused

		self.visible = is_paused;
		get_tree().paused = is_paused;
