extends CharacterBody2D

signal tile_broke

var direction : Vector2;

func _physics_process(_delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(velocity);
	if (!collision): return;

	var collider : Object = collision.get_collider();

	# If Tile, Delete
	if (collider.is_in_group("Tile")):
		get_node("TileAudio").play();
		tile_broke.emit();
		collider.queue_free();
	else:
		get_node("BounceAudio").play();

	if (collider.is_in_group("Player")): velocity = get_new_direction(collider)
	else: velocity = velocity.bounce(collision.get_normal());

func set_direction() -> void:
	var start_angle = deg_to_rad(randf_range(-70,70));
	velocity = Vector2.DOWN.rotated(start_angle) * 5;

func get_new_direction(collider : PhysicsBody2D) -> Vector2:
	# Get Distance from Center of Paddle
	var distance : float = position.x - collider.position.x;
	var new_direction : Vector2 = Vector2();

	# Determine which direction to bounce towards
	new_direction.y = -1;

	# Handle Y Bounce based on Paddle Colliding Point
	new_direction.x = (distance / collider.get_node("CollisionShape2D").shape.size.y / 2);
	return new_direction.normalized() * 5
