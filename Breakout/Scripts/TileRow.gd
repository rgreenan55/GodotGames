extends Node2D

func _process(_delta: float) -> void:
	if (get_child_count() == 0):
		queue_free();
