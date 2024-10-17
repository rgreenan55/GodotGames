extends Node2D

signal start_game;

func _process(delta: float) -> void:
	get_node("Background/Planet").rotation += 0.1 * delta;

func _on_play_game_button_pressed() -> void:
	start_game.emit();
