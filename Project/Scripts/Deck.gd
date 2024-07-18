extends Container

var DeckCards = []
var HandCardObj = preload("res://Objects/hand_cards.tscn")
@onready var PlayerContainer = $"../UI/PlayerContainer"
@onready var IAContainer = $"../UI/IAContainer"
@onready var played_cards = $"../Played Cards"
var newCard
var container
var hasToPick = false
var deckSize
@export var cardSpace: float  = 4.0
@export var maxWidth: float  = 850.0

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
	#if randi() % 2:
	#	GameManager.PlayerTurn = false
	
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
	deckSize = GameManager.PlayerHand.size() + 1

func give_card(hand: Array) -> Object:
	var last_card = DeckCards.pop_back()
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
			#currentCard.get_child(1).frame = last_card.texture
			currentCard.get_child(1).frame = 0
			IAContainer.add_child(currentCard)
			print("Card given to IA")
		_:
			currentCard = null
			return last_card
	return currentCard

func _process(delta):
	if GameManager.PlayerTurn:
		if deckSize != GameManager.PlayerHand.size():
			$DeckBody/Label.set_visible(true)
			hasToPick = true
			
			for card in GameManager.PlayerHand:
				if card.color == GameManager.PlayedCards.back().color ||  card.number == GameManager.PlayedCards.back().number:
					$DeckBody/Label.set_visible(false)
					hasToPick = false
			deckSize = GameManager.PlayerHand.size()
			update_hand_layout()
	else:
		hasToPick = false
		$DeckBody/Label.set_visible(false)

func update_hand_layout():
	var cardsAmount = PlayerContainer.get_child_count()
	if cardsAmount == 0:
		return
	
	var cardWidth = PlayerContainer.get_child(0).size.x
	var totalWidth = (cardWidth + cardSpace) * cardsAmount - cardSpace
	
	var scaleFactor = 1.0
	if totalWidth > maxWidth:
		scaleFactor = maxWidth / totalWidth
	
	var start_x = ((maxWidth - totalWidth * scaleFactor) / 2.0) + 160.0
	for i in range(cardsAmount):
		var card = PlayerContainer.get_child(i)
		card.scale = Vector2(scaleFactor, scaleFactor)
		card.global_position.x = start_x + i * (cardWidth * scaleFactor + cardSpace * scaleFactor)

func _on_deck_body_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton) and (event.button_index == 1) and (hasToPick):
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			container = "Player"
			newCard = give_card(GameManager.PlayerHand)
			newCard.fromPlayer = true
			$DeckBody/Label.set_visible(false)
			hasToPick = false
			
			if DeckCards.size() < 1:
				while GameManager.PlayedCards.size() > 1:
					DeckCards.push_back(GameManager.PlayedCards.pop_front())
				DeckCards.shuffle()
			
