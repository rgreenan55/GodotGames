extends Node2D

# Exports
@export var BallNode : PackedScene;

# Node References
@onready var PlayerScoreLabel : Label = $UserInterface/PlayerScore
@onready var OpponentScoreLabel : Label = $UserInterface/OpponentScore

# Variables
var GoalOnPlayer : int = 0;
var GoalOnOpponent : int = 0;

func reset_game(body : PhysicsBody2D) -> void:
	body.queue_free()
	var Ball = BallNode.instantiate();
	Ball.position = $Camera.get_screen_center_position();
	$Bodies.call_deferred("add_child", Ball);

func _player_goal_entered(body : PhysicsBody2D) -> void:
	if (body.is_in_group("Ball")):
		GoalOnPlayer += 1;
		OpponentScoreLabel.text = str(GoalOnPlayer);
		reset_game(body);

func _opponent_goal_entered(body : PhysicsBody2D) -> void:
	if (body.is_in_group("Ball")):
		GoalOnOpponent += 1;
		PlayerScoreLabel.text = str(GoalOnOpponent);
		reset_game(body);

