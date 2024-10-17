extends CharacterBody2D

const SPEED : int = -50;

var active : bool = true;

signal laser_destroyed;

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

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (!active): return;
	if(body.is_in_group("PlayerLaser")):
		velocity = Vector2.ZERO;
		active = false;
		laser_destroyed.emit();
		body.explode()
		explode();
	elif(body.is_in_group("Player")):
		body.on_hit();
		explode();
