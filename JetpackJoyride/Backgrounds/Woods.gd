extends ParallaxBackground

@export var scrolling_speed : float  = 1;

func _process(delta: float) -> void:
	scroll_offset.x -= scrolling_speed;
