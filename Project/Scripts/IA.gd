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
			GameManager.PlayerTurn = !GameManager.PlayerTurn
		else:
			var obj = deck.IAContainer.get_child(selectedIndex)
			GameManager.IAHand.remove_at(selectedIndex)
			isChoosing = true
			await get_tree().create_timer(1.0).timeout
			GameManager.PlayedCards.push_back(choosenCard)
			isChoosing = false
			if choosenCard.number == 10:
				GameManager.PlayerTurn = false
			else:
				GameManager.PlayerTurn = !GameManager.PlayerTurn
			
			if obj != null:
				obj.queue_free()
			else:
				print("Object is null?")
			
			if GameManager.IAHand.size() == 1:
				$"../../Uno".get_child(0).play("uno")
				$"../../SFX".stream = load("res://Audio/SFXs/UNO.mp3")
				$"../../SFX".play()
