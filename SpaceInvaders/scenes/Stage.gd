class_name Stage extends Node2D

signal level_complete;
signal reset_game;
signal quit_game;

var score_adder_scene : PackedScene = preload("res://ui/ScoreAdder.tscn");

enum EnemyType { BLUE, GREEN, RED, YELLOW, ORANGE }

@export var stage_enemies : Array;
var enemy_count : int = 55;

var player_health : int = 3;

func _ready() -> void:
	set_enemies();
	get_node("Player").connect("player_hit", on_player_hit);
	get_node("Overlay/ScoreBox/Score").text = "Score: %s" % str(get_parent().total_score);
	get_node("Overlay/Stage").text = "Stage %s" % str(get_parent().current_level);

func set_enemies(do_clear: bool = false) -> void:
	if (do_clear): get_node("EnemySpawnArea").clear_matrix();
	var converted_level_enemies : Array[EnemyType] = [];
	for n in stage_enemies: converted_level_enemies.push_back(EnemyType.get(EnemyType.keys()[n]));
	get_node("EnemySpawnArea").enemy_rows = converted_level_enemies;
	get_node("EnemySpawnArea").init();

func enemy_killed(points : int):
	enemy_count -= 1;
	add_to_score(points, Color.GOLD);
	if (enemy_count <= 0):
		get_tree().paused = true;
		get_node("Completed").visible = true;

func laser_destroyed():
	add_to_score(10, Color.WHITE);

func on_player_hit() -> void:
	get_node("Overlay/HBoxContainer").get_child(3 - player_health).visible = false;
	player_health -= 1;
	if (player_health <= 0): game_over();

func add_to_score(points : int, color : Color) -> void:
	get_parent().total_score += points;
	var score_adder : Label = score_adder_scene.instantiate();
	score_adder.label_settings.font_color = color;
	score_adder.text = "+" + str(points);
	get_node("Overlay/ScoreBox/ScoreAdders").add_child(score_adder);
	get_node("Overlay/ScoreBox/Score").text = "Score: %s" % str(get_parent().total_score);

func _on_game_over_border_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Enemy")): game_over();

func game_over() -> void:
	get_tree().paused = true;
	get_node("GameOver").visible = true;

func _on_quit_game_pressed() -> void:
	get_tree().paused = false;
	quit_game.emit();

func _on_reset_game_pressed() -> void:
	get_tree().paused = false;
	reset_game.emit();

func _on_next_level_pressed() -> void:
	get_tree().paused = false;
	level_complete.emit();
