extends Node2D

func _ready():
	GameManager.Scene = "End"
	GameManager.gameStarted = false
	var winner = GameManager.Winner
	winner += " Wins!"
	$VBoxContainer/Winner.text = winner



func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")



func _on_exit_button_pressed():
	get_tree().quit()
