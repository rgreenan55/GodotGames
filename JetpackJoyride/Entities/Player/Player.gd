extends CharacterBody2D

signal start_game;
signal player_died;

const GRAVITY : float = 5;
const JETPACK : float = -10;

var started : bool = false;
var is_dead : bool = false;

@onready var animation_player : AnimationPlayer = get_node("Sprite/AnimationPlayer");

func _ready() -> void:
	velocity = Vector2.ZERO;
	await animation_player.animation_finished;
	started = true;
	emit_signal("start_game");

func _process(delta: float) -> void:
	if (is_dead || !started): return;
	if (is_on_floor()): animation_player.play("running");
	else: animation_player.play("flying");

func _physics_process(delta: float) -> void:
	if (is_dead || !started): return;
	if (Input.is_action_pressed("Jetpack")):
		velocity.y += JETPACK;
	velocity.y += GRAVITY;
	move_and_slide();

func on_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Obstacle")):
		is_dead = true;
		emit_signal("player_died");
		animation_player.play("dying");
		await animation_player.animation_finished;
		queue_free();
