tool
extends Interactable
export var number = "0" setget set_number

var interaction_text = "interact with keypad button"

signal on_interact

func set_number(value):
	number = value
	if value:
		$Viewport/Label.text = str(value)


func get_interaction_text():
	return interaction_text

func interact():
	emit_signal("on_interact", number)
