extends Label

func _process(delta: float) -> void:
	position.y -= 10 * delta;

func _on_timer_timeout() -> void:
	queue_free();
