extends Button

@onready var container_buttons : Node = get_parent().get_parent()
var entity_editor : Node
var property_button : Node

@export var add_value : float = 1.0


func _ready() -> void:
	property_button = get_parent().get_parent().get_parent()
	entity_editor = get_tree().get_first_node_in_group("entity_editor")
	
	await get_tree().create_timer(1, true).timeout
	
	if "cooldown" in property_button.property_name:
		add_value /= 100
	
	text = str(add_value)


func _on_pressed() -> void:
	if property_button.type == "Vector2":
	
		if property_button.button_affect_axis == "x":
			property_button.property_value.x += add_value
		
		elif property_button.button_affect_axis == "y":
			property_button.property_value.y += add_value
	
	
	elif property_button.type == "Array":
		if property_button.property_value[int(property_button.button_affect_position)] is not String:
		
			if property_button.button_affect_axis == "x":
				property_button.property_value[int(property_button.button_affect_position)].x += add_value
			
			elif property_button.button_affect_axis == "y":
				property_button.property_value[int(property_button.button_affect_position)].y += add_value
	
	
	elif property_button.type == "int_float":
		property_button.property_value += add_value
	
	
	property_button.apply_value()
	
	property_button._on_mouse_exited(false)
	property_button._on_mouse_entered()
