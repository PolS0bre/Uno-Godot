extends HBoxContainer

@onready var deck = $"../../Deck"
var isChoosing = false

func _process(delta):
	if !GameManager.PlayerTurn && !isChoosing:
		var hasCard = false
		
		var indexHand = 0
		var selectedIndex = 0
		var choosenCard = null
		while !hasCard && GameManager.IAHand.size() - 1 > indexHand:
			choosenCard = GameManager.IAHand[indexHand]
			if choosenCard.number == GameManager.PlayedCards.back().number || choosenCard.color == GameManager.PlayedCards.back().color:
				hasCard = true
				selectedIndex = indexHand
				indexHand = GameManager.IAHand.size() + 1
			indexHand += 1
		
		if !hasCard:
			deck.container = "AI"
			var newCard = deck.give_card(GameManager.IAHand)
			newCard.fromPlayer = false
		else:
			GameManager.IAHand.remove_at(selectedIndex)
			isChoosing = true
			await get_tree().create_timer(1.0).timeout
			GameManager.PlayedCards.push_back(choosenCard)
			var obj = deck.IAContainer.get_child(selectedIndex)
			obj.queue_free()
			isChoosing = false
			GameManager.PlayerTurn = !GameManager.PlayerTurn
