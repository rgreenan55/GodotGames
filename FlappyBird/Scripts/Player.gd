extends CharacterBody2D

signal game_over;

const GRAVITY : float = 400;
const LIFT : float = -15000;

func _process(_delta : float):
	if (position.y < 0 || position.y > 720):
		game_over.emit();

func _physics_process(delta : float):
	if (Input.is_action_just_pressed("jump")):
		velocity.y = LIFT * delta;
	velocity.y += GRAVITY * delta;
	move_and_slide();
