extends Node

var PlayerHand = []
var IAHand = []
var PlayedCards = []
var Winner: String = ""

var PlayerTurn = true
var cardSelected
var mouseOnPlacement = false
var gameStarted = false
var Scene = "Game"

func _process(delta):
	if Scene == "Game" && gameStarted:
		if IAHand.size() <= 0:
			reset_hands()
			Winner = "AI"
			get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
		elif PlayerHand.size() <= 0:
			reset_hands()
			Winner = "Player"
			get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")

func reset_hands():
	PlayerHand.clear()
	IAHand.clear()
	PlayedCards.clear()
