extends RayCast

var current_collider: Object
onready var interaction_label = get_node("/root/World/UI/InteractionLabel")

func _ready():
	set_interaction_text("")

func _process(_delta):
	var collider = get_collider()
	if is_colliding() and collider is Interactable:
		if current_collider != collider:
			set_interaction_text(collider.get_interaction_text())
			current_collider = collider

		if Input.is_action_just_pressed("interact"):
			current_collider.interact()
			set_interaction_text(collider.get_interaction_text())
	elif is_instance_valid(current_collider):
		current_collider = null
		set_interaction_text("")
	pass

func set_interaction_text(text):
	if !text:
		interaction_label.visible = false
	else:
		var interact_key = OS.get_scancode_string(InputMap.get_action_list("interact")[0].scancode)
		interaction_label.text = "Press %s to %s" % [interact_key, text]
		interaction_label.visible = true
