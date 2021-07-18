extends Spatial

onready var door = $Door

func _on_Keypad_on_correct_password(password):
	print("correct password")
	door.open()
