extends CharacterBody2D

@onready var SPEED : int = 500;

var ball : CharacterBody2D;
var ball_position : Vector2;

func _process(delta : float) -> void:
	position.x = 200;
	if (!ball): return;

	var goal_position = ball.position.y if ball.velocity.x < 0 else 1080/2

	var distance : float = position.y - goal_position;
	var move_distance : float = 0

	if (abs(distance) > SPEED * delta):
		move_distance = distance/abs(distance) * SPEED * delta;
	else:
		move_distance = distance;
	position.y -= move_distance;

func _physics_process(delta : float) -> void:
	move_and_slide();
