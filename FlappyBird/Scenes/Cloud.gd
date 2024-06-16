extends Sprite2D

const SPEED : float = 150;

func _process(delta : float):
	position.x -= SPEED * delta;
