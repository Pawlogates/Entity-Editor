extends Button

@onready var container_choices : Node = get_parent().get_parent()
var entity_editor : Node
var property_button : Node

var choice_value = -1
var choice_name : String = "none"


func _ready() -> void:
	property_button = get_parent().get_parent().get_parent()
	entity_editor = get_tree().get_first_node_in_group("entity_editor")
	
	text = choice_name


func _on_pressed() -> void:
	text = choice_name
	
	property_button.property_value = choice_value
	property_button.apply_value()
	
	property_button._on_mouse_exited(0)
	property_button._on_mouse_entered()
	
	container_choices.visible = false
	
	entity_editor.display_controls.visible = true
	for node in entity_editor.container_property_buttons.get_children():
		node.mouse_filter = 0
		node.modulate = Color.WHITE
	
	property_button._on_mouse_exited(2)
