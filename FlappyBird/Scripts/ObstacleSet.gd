extends Node2D

signal player_goal;
signal game_over;

@onready var top_obstacle : Area2D = get_node("TopObstacle");
@onready var bottom_obstacle : Area2D = get_node("BottomObstacle");
@onready var goal_collision : CollisionShape2D = get_node("GoalCollision");

const SPEED : float = 200;

func _ready():
	var window_y : float = get_viewport_rect().size.y;
	top_obstacle.position.y = -window_y / 2;
	bottom_obstacle.position.y = window_y / 2;

	var variant : float = randf_range(-2, 2);
	top_obstacle.scale.y += variant;
	bottom_obstacle.scale.y += variant;

func _process(delta : float):
	position.x -= SPEED * delta;

func _body_entered_goal(body : PhysicsBody2D):
	if (body.is_in_group("Player")): player_goal.emit();

func _body_entered_obstacle(body : PhysicsBody2D):
	if (body.is_in_group("Player")): game_over.emit();

