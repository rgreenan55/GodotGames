extends CharacterBody2D

var Ball : CharacterBody2D;
var SPEED : int = 500;

func _process(delta : float) -> void:
	position.x = 200;

func _physics_process(delta : float) -> void:
	move_and_slide();




