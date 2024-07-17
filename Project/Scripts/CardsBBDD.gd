extends Resource
class_name Card

@export var type : String
@export var color : Color
@export var number : int
# @export var texture : Image

func ability():
	match type:
		'Normal':
			return
		'Block':
			#Do function to block the other player
			return
		_:
			return
