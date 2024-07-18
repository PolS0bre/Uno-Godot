extends Container

var startPosition
var cardHighlighted = false
var picked = false
var inZone = false
var cardObj
var fromPlayer = true

func _on_mouse_entered():
	if fromPlayer:
		$AnimationPlayer.play("Select")
		cardHighlighted = true

func _on_mouse_exited():
	if fromPlayer:
		$AnimationPlayer.play("Deselect")
		cardHighlighted = false

func _on_gui_input(event):
	if (event is InputEventMouseButton) and (event.button_index == 1) and (fromPlayer):
		if event.button_mask == 1:
			set_start_pos()
			picked = true
		elif event.button_mask == 0:
			if inZone:
				if cardObj.color == GameManager.PlayedCards.back().color || cardObj.number == GameManager.PlayedCards.back().number:
					GameManager.PlayedCards.push_back(cardObj)
					GameManager.PlayerTurn = !GameManager.PlayerTurn
					hand_card_delete()
				else:
					picked = false
					self.global_position = startPosition
			else:
				picked = false
				self.global_position = startPosition

func _process(delta):
	if picked:
		self.global_position = get_global_mouse_position() + Vector2(-42, -30)

func _ready():
	if get_parent().name == "IAContainer":
		fromPlayer = false

func set_start_pos():
	startPosition = self.global_position

func hand_card_delete():
	var index = GameManager.PlayerHand.find(cardObj)
	var obj = GameManager.PlayerHand.pop_at(index)
	queue_free()
	

func _on_body_col_area_entered(area):
	if area.get_parent().name == "Played Cards":
		inZone = true

func _on_body_col_area_exited(area):
	if area.get_parent().name == "Played Cards":
		inZone = false
