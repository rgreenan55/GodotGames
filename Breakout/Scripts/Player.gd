extends StaticBody2D

@onready var WIDTH : float = get_node("CollisionShape2D").shape.size.x;

func _process(_delta: float) -> void:
	var mouse_position : Vector2 = get_global_mouse_position();
	var min_pos = 5+WIDTH/2;
	var max_pos = get_viewport_rect().size.x - 5 - WIDTH/2;
	position.x = clamp(mouse_position.x, min_pos, max_pos);
