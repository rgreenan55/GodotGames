extends CharacterBody2D

var SPEED : int = 500;

func _process(delta : float) -> void:
	position.x = clamp(position.x, 0, 1920);
	position.y= clamp(position.y, 0, 1080);

func _physics_process(delta : float) -> void:
	var collision : KinematicCollision2D = move_and_collide(velocity * delta);
	if (collision):
		velocity = velocity.bounce(collision.get_normal());
		if (collision.get_collider().is_in_group("Paddle")):
			SPEED += 100;
			velocity = velocity.normalized() * SPEED;

func _start_ball() -> void:
	velocity = Vector2.RIGHT * SPEED;
	velocity = velocity.rotated(deg_to_rad(randf_range(-50,50)));
