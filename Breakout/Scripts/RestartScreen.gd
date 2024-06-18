extends CanvasLayer

func _on_restart() -> void:
	get_tree().paused = false;
	get_tree().reload_current_scene();
