extends Node2D

@onready var score_timer : Timer = $Timers/ScoreTimer
@onready var distance_label : Label = $GameInterface/GameUI/Distance;
var distance : int = 0;

@export var worm_scene : PackedScene;
@onready var worms_label : Label = $GameInterface/GameUI/Worms;
@onready var worm_timer : Timer = $Timers/WormTimer
var worms : int = 0;

@export var top_obstacle_options : Array[PackedScene];
@export var mid_obstacle_options : Array[PackedScene];
@export var bot_obstacle_options : Array[PackedScene];
@onready var obstacle_options : Array[Array] = [top_obstacle_options, mid_obstacle_options, bot_obstacle_options];
@onready var obstacle_spawners : Array = get_node("ObstacleSpawns").get_children();
@onready var obstacle_timer : Timer = $Timers/ObstacleTimer

var is_player_dead : bool = false;
var game_started : bool = false;

func _ready() -> void:
	get_node("Player").connect("player_died", player_died);
	get_node("Player").connect("start_game", start_game);

func _physics_process(delta: float) -> void:
	var obstacles = get_node("Obstacles").get_children();
	for obstacle in obstacles:
		obstacle.position.x -= 2.5;
		if obstacle.position.x < -40:
			obstacle.queue_free();

func start_game() -> void:
	game_started = true;
	get_node("Terrain/Woods").scrolling_speed = 0.75;
	worm_timer.start();
	obstacle_timer.start();
	score_timer.start();


func player_died() -> void:
	is_player_dead = true;
	get_node("GameInterface/GameOver").visible = true;

func worm_collected() -> void:
	worms += 1;
	worms_label.text = str(worms).pad_zeros(3);

func increase_distance() -> void:
	if (is_player_dead): return;
	distance += 1;
	distance_label.text = str(distance).pad_zeros(4) + "m"

func spawn_worm() -> void:
	var worm = worm_scene.instantiate();
	worm.connect("worm_collected", worm_collected);
	worm.position.x = 680;
	worm.position.y = randf_range(10, 310);
	get_node("Worms").add_child(worm);
	worm_timer.wait_time = randf_range(4.0, 8.0);
	worm_timer.start();

func spawn_obstacle() -> void:
	var position_id = randi_range(0, 2);
	var spawn_position = obstacle_spawners[position_id].position;
	var obstacle = obstacle_options[position_id].pick_random().instantiate();
	obstacle.position = spawn_position;
	if (position_id == 1): obstacle.position.y += randf_range(-50, 50);
	get_node("Obstacles").add_child(obstacle);


func on_retry_button_pressed() -> void:
	get_tree().reload_current_scene();

func _on_exit_button_pressed() -> void:
	get_tree().quit()

