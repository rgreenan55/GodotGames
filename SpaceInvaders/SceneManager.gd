extends Node2D

enum EnemyType { BLUE, GREEN, RED, YELLOW, ORANGE }

@export var stage_scene : PackedScene;
@export var title_scene : PackedScene;

@export var total_score : int = 0;

@export var current_level : int = 0;
var stage_enemies : Array[Array] = [
	[EnemyType.BLUE, EnemyType.BLUE, EnemyType.GREEN, EnemyType.GREEN, EnemyType.RED],
	[EnemyType.BLUE, EnemyType.GREEN, EnemyType.GREEN, EnemyType.RED, EnemyType.YELLOW],
	[EnemyType.BLUE, EnemyType.GREEN, EnemyType.RED, EnemyType.YELLOW, EnemyType.ORANGE],
	[EnemyType.GREEN, EnemyType.RED, EnemyType.YELLOW, EnemyType.ORANGE, EnemyType.ORANGE],
	[EnemyType.BLUE, EnemyType.BLUE, EnemyType.BLUE, EnemyType.BLUE, EnemyType.BLUE],
];

func _ready():
	var title_node = title_scene.instantiate();
	title_node.name = "title";
	title_node.connect("start_game", _on_title_screen_start_game);
	add_child(title_node);

func next_level():
	current_level += 1;
	# Remove Previous Level
	var level_node = get_node_or_null("level")
	if (level_node != null): remove_child(level_node);
	# Add New Level
	var stage_node : Stage = stage_scene.instantiate();
	stage_node.name = "level";
	stage_node.stage_enemies = stage_enemies[current_level % 5 - 1];
	stage_node.connect("level_complete", next_level);
	stage_node.connect("reset_game", reset_game);
	stage_node.connect("quit_game", quit_game);
	add_child(stage_node);

func reset_game():
	total_score = 0;
	current_level = 0;
	next_level();

func quit_game():
	remove_child(get_node("level"));
	_ready();

func _on_title_screen_start_game() -> void:
	remove_child(get_node("title"));
	next_level();
