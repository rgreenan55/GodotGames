extends CharacterBody2D

signal player_hit;

const SPEED : int = 100;

@export var laser_scene : PackedScene;

func _process(delta: float) -> void:
	position.x = clamp(position.x, 8, 312);
	velocity = handle_movement();
	handle_attack();

func _physics_process(delta: float) -> void:
	move_and_slide();

func handle_movement():
	var input_movement : float = Input.get_axis("move_left", "move_right");
	var horizontal_movement : int = floor(input_movement) if input_movement < 0 else ceil(input_movement);
	return Vector2(horizontal_movement, 0) * SPEED;

func handle_attack():
	if (Input.is_action_pressed("shoot") && get_node("AttackTimer").is_stopped()):
		var laser = laser_scene.instantiate();
		laser.position = position;
		get_node("../Disposables/PlayerLasers").add_child(laser);
		get_node("AttackTimer").start();

func on_hit():
	player_hit.emit();
