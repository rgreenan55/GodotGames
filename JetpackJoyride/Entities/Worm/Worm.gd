extends Area2D

signal worm_collected

func _process(delta: float) -> void:
	position.x -= 2.5;

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player")):
		emit_signal("worm_collected");
		# Play Sound
		# Particle Effect?
		queue_free();
