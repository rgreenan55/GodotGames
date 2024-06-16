extends Node2D

@export var ObstacleSetScene : PackedScene;
@export var CloudScene : PackedScene;

var score : int = 0;


func _ready():
	get_node("Objects/Player").connect("game_over", _on_game_over);

func _spawn_obstacle():
	get_node("Objects/SpawnObstacleTimer").wait_time = randf_range(2.0, 3.5);
	get_node("Objects/SpawnObstacleTimer").start();

	var obstacle_set = ObstacleSetScene.instantiate();
	obstacle_set.position.x = get_viewport_rect().size.x + 50;
	obstacle_set.position.y = get_viewport_rect().size.y / 2;
	obstacle_set.connect("game_over", _on_game_over);
	obstacle_set.connect("player_goal", _on_goal);
	get_node("Objects/Obstacles").add_child(obstacle_set);

func _spawn_cloud():
	get_node("Objects/SpawnCloudTimer").wait_time = randf_range(2, 5);
	get_node("Objects/SpawnCloudTimer").start();
	var cloud = CloudScene.instantiate();
	cloud.position.x = get_viewport_rect().size.x + 100;
	cloud.position.y = randf_range(0, get_viewport_rect().size.y-150);
	get_node("Objects/Clouds").add_child(cloud);


func _on_goal():
	score += 1;
	get_node("GoalSound").play();
	get_node("UserInterface/ScoreLabel").text = "Score: %s" % score;

func _on_game_over():
	get_tree().paused = true;
	get_node("UserInterface/GameOver").visible = true;
