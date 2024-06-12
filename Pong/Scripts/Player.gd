extends CharacterBody2D

var SPEED : int = 500

func _process(delta: float) -> void:
	position.x = 1720;

	var direction : float = Input.get_axis("move_up", "move_down");

	if (direction < 0): velocity = Vector2.UP
	elif (direction > 0): velocity = Vector2.DOWN
	else: velocity = Vector2.ZERO
	velocity *= SPEED

func _physics_process(delta : float) -> void:
	move_and_slide()
