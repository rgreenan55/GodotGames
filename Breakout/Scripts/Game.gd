extends Node2D

@export var BallNode : PackedScene;

var balls : int = 3;
var score : int = 0;

func _ready() -> void:
	get_node("Movers/Ball").connect("tile_broke", tile_broken);

func tile_broken():
	score += 1;
	var scoreText : String = "";
	if (score < 100): scoreText += "0";
	if (score < 10): scoreText += "0";
	scoreText += str(score);
	get_node("UserInterface/Score").text = scoreText;
	if (score == 72): game_end(false);				# I should have a better way to do this...

func _floor_entered(body: Node2D) -> void:
	if (body.is_in_group("Ball")):
		body.queue_free();
		ball_died();

func ball_died():
	balls -= 1;
	get_node("UserInterface/Balls").text = "00" + str(balls);
	get_node("Audio/GameOver").play();

	if (balls > 0):
		var Ball = BallNode.instantiate();
		Ball.position = Vector2(250, 250);
		get_node("Movers").add_child(Ball);
		get_node("Movers/Ball").connect("tile_broke", tile_broken);
	else:
		game_end(true);

func game_end(is_game_over : bool):
	if (is_game_over):
		get_node("RestartScreen/RestartText").text = "Game Over!"
	else:
		get_node("Audio/GameWin").play();
		get_node("RestartScreen/RestartText").text = "Game Win!"

	get_node("RestartScreen/Score").text = "Your Score: " + str(score);
	get_node("RestartScreen").visible = true;
	get_tree().paused = true;
