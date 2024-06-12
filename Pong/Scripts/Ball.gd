extends CharacterBody2D

var SPEED : int = 500;

# Start Ball Movement After 1 Second
func _start_ball() -> void:
	velocity = Vector2.RIGHT * SPEED;
	velocity = velocity.rotated(deg_to_rad(randf_range(-50,50)));

func _process(delta : float) -> void:
	position.x = clamp(position.x, 0, 1920);
	position.y= clamp(position.y, 0, 1080);

# Handles Collision
func _physics_process(delta : float) -> void:
	var collision : KinematicCollision2D = move_and_collide(velocity * delta);
	if (!collision): return;

	var collider : Object = collision.get_collider()
	if (collider.is_in_group("Paddle")):
		increase_speed();
		velocity = get_new_direction(collider) * SPEED;
	else:
		velocity = velocity.bounce(collision.get_normal());

# Gets new Direction after Collision
func get_new_direction(collider : CharacterBody2D) -> Vector2:
	# Get Distance from Center of Paddle
	var distance : float = position.y - collider.position.y;
	var new_direction : Vector2 = Vector2();

	# Determine which direction to bounce towards
	if (velocity.x > 0): new_direction.x = -1;
	else: new_direction.x = 1;

	# Handle Y Bounce based on Paddle Colliding Point
	new_direction.y = (distance / collider.get_node("CollisionShape2D").shape.size.x / 2);
	return new_direction.normalized()

func increase_speed() -> void:
		SPEED += 50;
