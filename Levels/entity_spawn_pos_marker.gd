extends ColorRect


func _on_gui_input(event: InputEvent) -> void:
	if Input.is_action_pressed("attack_main"):
		position = get_global_mouse_position()
