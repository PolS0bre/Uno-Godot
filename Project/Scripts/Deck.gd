extends StaticBody2D

var DeckCards = []
var HandCardObj = preload("res://Objects/hand_cards.tscn")
@onready var PlayerContainer = $"../UI/PlayerContainer"
@onready var IAContainer = $"../UI/IAContainer"
@onready var played_cards = $"../Played Cards"
var newCard
var container

func get_resources_of_class(directory_path: String, class_type: String) -> Array:
	var resources = []
	var dir = DirAccess.open(directory_path)
	
	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var resource_path = directory_path + "/" + file_name
			var resource = ResourceLoader.load(resource_path)
			
			resources.append(resource)
			if(resource.type != "Normal"):
				resources.append(resource)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	return resources

func initialize() -> void:
	DeckCards = get_resources_of_class("res://Objects/Cards", "Card")
	randomize()
	DeckCards.shuffle()
	
	GameManager.PlayerTurn = true
	if randi() % 2:
		GameManager.PlayerTurn = false
	
	var NumCards = 7
	while NumCards > 0:
		container = "Player"
		newCard = give_card(GameManager.PlayerHand)
		newCard.fromPlayer = true
		container = "AI"
		newCard = give_card(GameManager.IAHand)
		newCard.fromPlayer = false
		NumCards -= 1
	
	container = "Played"
	give_card(GameManager.PlayedCards)
	

func _ready():
	initialize()

func give_card(hand: Array) -> Object:
	var last_card = DeckCards.pop_back()
	print(last_card)
	hand.push_back(last_card)
	var currentCard
	match container:
		"Player":
			currentCard = HandCardObj.instantiate()
			currentCard.cardObj = last_card
			currentCard.get_child(1).frame = last_card.texture
			PlayerContainer.add_child(currentCard)
		"AI":
			currentCard = HandCardObj.instantiate()
			currentCard.cardObj = last_card
			currentCard.get_child(1).frame = last_card.texture
			IAContainer.add_child(currentCard)
		_:
			currentCard = null
			return last_card
	
	return currentCard
