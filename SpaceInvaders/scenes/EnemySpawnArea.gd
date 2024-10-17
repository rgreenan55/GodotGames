extends Area2D

enum EnemyType { BLUE, GREEN, RED, YELLOW, ORANGE }

@export var enemy_scene : PackedScene;
@export var enemy_rows : Array[EnemyType];

@export var enemy_laser_scene : PackedScene;

@export var mini_boss_scene : PackedScene;
var boss_spawned : bool = false;

const row_count : int = 5;
const col_count : int = 11;

# Each Index is a Column
var enemy_type_matrix : Array[Array] = [];
var enemy_matrix : Array[Array];

var width_spacing : float;
var height_spacing : float;

var currently_moving : bool = false;
var current_move_direction : int = -1;
var move_down_next : bool = false;
var move_delay : float = 0.1;

func init():
	currently_moving = false;
	current_move_direction = -1;
	move_down_next = false;
	move_delay = 0.1;

	# Setup Matrix
	enemy_type_matrix.resize(row_count);
	for index in range(enemy_type_matrix.size()):
		var row = [];
		row.resize(col_count);
		enemy_type_matrix[index] = row;
	enemy_matrix = enemy_type_matrix.duplicate(true);

	# Get Width/Height Spacing
	width_spacing = get_node("CollisionShape").shape.size.x / (col_count+1);
	height_spacing = get_node("CollisionShape").shape.size.y / (row_count);

	fill_matrix(enemy_rows);
	spawn_enemies();

func _process(delta: float) -> void:
	if (!currently_moving):
		move_enemies();

	if (boss_spawned && get_node("MiniBoss/MiniBossPath/PathFollower").progress_ratio < 1):
		get_node("MiniBoss/MiniBossPath/PathFollower").progress_ratio += 0.05 * delta;

func move_enemies() -> void:
	currently_moving = true;
	var move_down = move_down_next;

	for row_index in range(row_count):
		for column_index in range(col_count):
			var enemy = enemy_matrix[row_index][col_count - column_index - 1];
			if (!enemy or enemy.health <= 0): continue;

			if (enemy.get_node("Sprite").frame % 2 == 1): enemy.get_node("Sprite").frame -= 1
			else: enemy.get_node("Sprite").frame += 1

			if (move_down): enemy.position.y += 7.5;
			else:
				enemy.position.x += width_spacing/6 * current_move_direction;
				var check = enemy.position.x + (width_spacing/6 * current_move_direction);
				if (check < 8 || check > 312): move_down_next = true;

		if (get_tree()):
			var timer = get_tree().create_timer(move_delay);
			await timer.timeout;

	if (move_down):
		current_move_direction *= -1;
		move_down_next = false;
		if (move_delay > 0.001): move_delay *= 0.8;
	currently_moving = false;

func fill_matrix(enemy_types : Array[EnemyType]) -> void:
	for row_index in range(row_count):
		for column_index in range(col_count):
			enemy_type_matrix[row_index][column_index] = enemy_types[row_index];

func spawn_enemies() -> void:
	for row_index in range(enemy_type_matrix.size()):
		for column_index in range(enemy_type_matrix[row_index].size()):
			var enemy : GeneralEnemy = enemy_scene.instantiate();
			enemy.enemy_type = enemy_type_matrix[row_index][enemy_type_matrix[row_index].size() - column_index - 1];
			enemy.position = Vector2((column_index+1)*width_spacing, height_spacing*row_count-row_index*height_spacing) + Vector2(16, 48);
			enemy_matrix[row_index][column_index] = enemy;
			enemy.connect("killed", get_parent().enemy_killed);
			add_child(enemy);

func clear_matrix() -> void:
	for row_index in range(row_count):
		for column_index in range(col_count):
			var enemy_check = enemy_matrix[row_index][column_index];
			if (enemy_check && is_instance_valid(enemy_check)): enemy_check.queue_free();
			enemy_type_matrix[row_index][column_index] = null;
			enemy_matrix[row_index][column_index] = null;

func mini_boss_spawn_check():
	if (randi_range(1, 10) == 1):
		var mini_boss = mini_boss_scene.instantiate();
		mini_boss.connect("killed", get_parent().add_to_score);
		get_node("MiniBoss/MiniBossPath/PathFollower").add_child(mini_boss);
		boss_spawned = true;
	else:
		get_node("MiniBoss/MiniBossDelayTimer").start(5);

func _on_enemy_shoot_timer_timeout() -> void:
	var column_index = randi_range(0, col_count-1);
	var row_index = 0;
	var shooting_alien = null;
	while shooting_alien == null && row_index < row_count:
		shooting_alien = enemy_matrix[row_index][column_index];
		row_index += 1;
	if (shooting_alien && is_instance_valid(shooting_alien)):
		var enemy_laser = enemy_laser_scene.instantiate();
		enemy_laser.position = shooting_alien.position;
		enemy_laser.connect("laser_destroyed", get_parent().laser_destroyed);
		get_node("../Disposables/EnemyLasers").add_child(enemy_laser);
	get_node("EnemyShootTimer").start(randf_range(0.5, 3));
