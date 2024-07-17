extends Node2D

@onready var card_sprite = $"Card Sprite"
var size_deck = 0

func _process(delta):
	if (GameManager.PlayedCards.size() != size_deck):
		card_sprite.frame = GameManager.PlayedCards.back().texture
		size_deck = GameManager.PlayedCards.size()
