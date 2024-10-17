class_name GeneralEnemy extends Node2D

signal killed;
enum EnemyType { BLUE, GREEN, RED, YELLOW, ORANGE, PURPLE }

@export var max_health : int = 1;
@export var health : int = max_health;
@export var enemy_type : EnemyType :
	set (value):
		if (value == EnemyType.PURPLE): return;
		get_node("Sprite").frame = value*2;
		max_health = floor(value/2.0)+1
		health = max_health;
var dead : bool = false;

func _process(delta: float) -> void:
	if (health <= 0): enemy_death();

func enemy_death() -> void:
	if (dead): return;
	dead = true;
	get_node("Sprite").visible = false;
	get_node("CollisionArea/CollisionShape").set_deferred("disabled", true);
	get_node("DeathParticles").emitting = true;
	await get_node("DeathParticles").finished;
	# play sound
	# death animation?
	killed.emit(max_health * 50);
	queue_free();

func _on_collision_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("PlayerLaser")):
		health -= 1;
		body.explode();
