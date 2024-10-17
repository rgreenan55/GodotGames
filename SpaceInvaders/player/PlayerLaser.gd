extends CharacterBody2D

const SPEED : int = 100;

func _process(delta: float) -> void:
	velocity = Vector2(0, -1) * SPEED;

func _physics_process(delta: float) -> void:
	move_and_slide();

func explode():
	get_node("CollisionShape").set_deferred("disabled", true);
	get_node("Sprite").visible = false;
	get_node("ExplodeParticles").emitting = true;
	await get_node("ExplodeParticles").finished;
	queue_free();
