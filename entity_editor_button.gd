extends Button

@onready var entity_editor : Control = get_parent().get_parent()

@onready var scan_visible_right: VisibleOnScreenNotifier2D = $container_choices/scan_visible_right
@onready var scan_visible_left: VisibleOnScreenNotifier2D = $container_choices/scan_visible_left
@onready var scan_visible_top: VisibleOnScreenNotifier2D = $container_choices/scan_visible_top
@onready var scan_visible_bottom: VisibleOnScreenNotifier2D = $container_choices/scan_visible_bottom

var property_name_active = false

@onready var text_manager: Control = $bg/text_manager
@onready var bg: ColorRect = $bg

@onready var display_value: Control = $display_value
@onready var display_value_text_manager: Control
@onready var display_value_bg: ColorRect = $display_value/bg
@onready var display_value_property_name: Label = $display_value/label_property_name
@onready var display_value_property_value_type: Label = $display_value/label_property_value_type

@onready var container_choices: Control = $container_choices


var property_name : String = "none"
var property_value = -1

@export_enum("bool", "int_float", "Array", "Vector2", "String") var type : String = "bool"


func _ready() -> void:
	custom_minimum_size.x = 182
	await get_tree().create_timer(0.5, true).timeout
	#Globals.weapon["apply_default"] = false
	Globals.weapon.get_or_add(property_name, property_value)
	if is_instance_valid(display_value) : display_value.visible = false
	
	if "collectable" in property_name : bg.material = Globals.material_rainbow
	elif property_name == "patrolling" : bg.material = Globals.material_rainbow
	
	# Prepare choices (String):
	if type == "String":
		
		if "start_animation" in property_name:
			
			bg.material = Globals.material_rainbow
			
			for choice in Globals.l_animation_name_general_all + Globals.l_animation_name_gear_all:
				
				var choice_button = load("res://entity_editor_choice.tscn").instantiate()
				
				choice_button.choice_value = choice
				choice_button.choice_name = str(choice)
				
				$container_choices/container.add_child(choice_button)
		
		if "sprite_filepath" in property_name:
			
			bg.material = Globals.material_rainbow
			
			for choice in Globals.l_sprite_entity:
				
				var choice_button = load("res://entity_editor_choice.tscn").instantiate()
				
				choice_button.choice_value = choice
				
				if "res://Assets/Graphics/sprites/packed/" in str(choice):
					choice_button.choice_name = str(choice).replace("res://Assets/Graphics/sprites/packed/", "")
				
				$container_choices/container.add_child(choice_button)
		
		# EXCEPTION 4 (message) - [START]
		if "text_message" in property_name:
			
			bg.material = Globals.material_rainbow
			
			for choice in Globals.l_color_all:
				if Globals.random_bool(1, 1) : continue
				
				var choice_button = load("res://entity_editor_choice.tscn").instantiate()
				
				choice_button.choice_value = choice
				choice_button.choice_name = str(choice)
				
				$container_choices/container.add_child(choice_button)
		# EXCEPTION 4 (message) - [END]
		
		# EXCEPTION 3 (sfx) - [START]
		if "sfx" in property_name and "filepath" in property_name:
			
			for choice in Globals.l_sfx:
				var choice_button = load("res://entity_editor_choice.tscn").instantiate()
				
				choice_button.choice_value = choice
				choice_button.choice_name = str(choice)
				
				$container_choices/container.add_child(choice_button)
		# EXCEPTION 3 (sfx) - [END]
		
		# EXCEPTION 1 (entity movement type) - [START]
		if "movement_type" in property_name or "gain_movement" in property_name:
			
			bg.material = Globals.material_rainbow
			
			for choice in Globals.l_entity_movement_all:
				var choice_button = load("res://entity_editor_choice.tscn").instantiate()
				
				choice_button.choice_value = choice
				
				if "res://Assets/Sounds/sfx/" in str(choice):
					choice_button.choice_name = str(choice).replace("res://Assets/Sounds/sfx/", "")
				
				else:
					choice_button.choice_name = str(choice)
				
				$container_choices/container.add_child(choice_button)
		# EXCEPTION 1 (entity movement type) - [END]
		
		# EXCEPTION 2 (entity scene filepath) - [START]
		if "scene_filepath" in property_name or "entity_filepath" in property_name:
			
			bg.material = Globals.material_rainbow
			
			for choice in Globals.l_entity:
				var choice_button = load("res://entity_editor_choice.tscn").instantiate()
				
				choice_button.choice_value = choice
				
				if "res://Collectibles/" in str(choice):
					choice_button.choice_name = str(choice).replace("res://Collectibles/", "")
				elif "res://Enemies/" in str(choice):
					choice_button.choice_name = str(choice).replace("res://Enemies/", "")
				elif "res://Boxes/" in str(choice):
					choice_button.choice_name = str(choice).replace("res://Boxes/", "")
				elif "res://Projectiles/" in str(choice):
					choice_button.choice_name = str(choice).replace("res://Projectiles/", "")
				
				
				$container_choices/container.add_child(choice_button)
		# EXCEPTION 2 (entity scene filepath) - [END]
		
		
		var fully_visible = false
		var relocation_attempts = 0
		
		while not fully_visible and relocation_attempts < 1200:
			#print("Adjusting display position because it isn't visible.")
			
			container_choices.visible = true
			
			if scan_visible_right.is_on_screen() and scan_visible_left.is_on_screen() and scan_visible_top.is_on_screen() and scan_visible_bottom.is_on_screen():
				fully_visible = true
			
			if not scan_visible_right.is_on_screen() : container_choices.position.x += -40
			if not scan_visible_left.is_on_screen() : container_choices.position.x += 40
			if not scan_visible_top.is_on_screen() : container_choices.position.y += 40
			if not scan_visible_bottom.is_on_screen() : container_choices.position.y += -40
			
			relocation_attempts += 1
			
			await get_tree().create_timer(randf_range(0.01, 0.1), true).timeout
		
		container_choices.visible = false
		
		if fully_visible : Globals.dm("Relocation was successful")
		else : Globals.dm("Relocation has failed.")


func handle_type():
	call("handle_" + type)
	check_value()

func handle_bool():
	check_property_name()

func handle_int_float():
	check_property_name()

func handle_Array():
	check_property_name()

func handle_Vector2():
	check_property_name()

func handle_String():
	check_property_name()


func _on_pressed() -> void:
	if type != "bool" and type != "String": Globals.World.camera.override_camera_pos = position - Vector2(1600/2, 1100/2)
	
	Globals.spawn_scenes(entity_editor, Globals.scene_particle_star, 4, position + size / 2 + Vector2(32, 32) + Vector2(randi_range(-32, 32), randi_range(-16, 16)))
	Globals.spawn_scenes(entity_editor, Globals.scene_particle_special, 4, position + size / 2 + Vector2(32, 32) + Vector2(randi_range(-32, 32), randi_range(-16, 16)))
	entity_editor.sfx_manager.sfx_play(Globals.l_sfx_menu_stabilize.pick_random(), randf_range(0.75, 1.25), randf_range(0.75, 1.25))
	
	if type == "bool":
		property_value = Globals.opposite_bool(property_value)
	
	elif type == "Array":
		entity_editor.display_controls.visible = false
		
		$container_buttons.visible = Globals.opposite_bool($container_buttons.visible)
		entity_editor.display_controls.visible = false
		for property_button in get_parent().get_children():
			property_button.mouse_filter = 2
			property_button.modulate = Color(1, 0.5, 0.5, 0.5)
			modulate = Color.WHITE
	
	elif type == "String":
		entity_editor.display_controls.visible = false
		
		$container_choices.visible = Globals.opposite_bool($container_choices.visible)
		for property_button in get_parent().get_children():
			property_button.mouse_filter = 2
			property_button.modulate = Color(1, 0.5, 0.5, 0.5)
			modulate = Color.WHITE
	
	elif type == "int_float":
		entity_editor.display_controls.visible = false
		
		$container_buttons.visible = Globals.opposite_bool($container_buttons.visible)
		for property_button in get_parent().get_children():
			property_button.mouse_filter = 2
			property_button.modulate = Color(1, 0.5, 0.5, 0.5)
			modulate = Color.WHITE
	
	elif type == "Vector2":
		entity_editor.display_controls.visible = false
		
		$container_buttons.visible = Globals.opposite_bool($container_buttons.visible)
		for property_button in get_parent().get_children():
			property_button.mouse_filter = 2
			property_button.modulate = Color(1, 0.5, 0.5, 0.5)
			modulate = Color.WHITE
	
	
	if type == "bool":
		apply_value()
	
	check_value()


func check_value():
	if type == "bool":
		if Globals.weapon.has(property_name):
			if Globals.weapon[property_name] : bg.self_modulate = Color.DARK_GREEN
			else : bg.self_modulate = Color.DARK_RED
	
	else:
		display_value_property_value_type.text = type
		display_value_property_name.text = property_name
		
		if type == "int_float":
			bg.self_modulate = Color.SKY_BLUE
			bg.self_modulate = bg.self_modulate.blend(Color(1, 1, 1, 0.5))
		
		elif type == "String":
			bg.self_modulate = Color.ORANGE
			bg.self_modulate = bg.self_modulate.blend(Color(1, 1, 1, 0.5))
		
		elif type == "Vector2":
			bg.self_modulate = Color.WEB_PURPLE
			bg.self_modulate = bg.self_modulate.blend(Color(1, 1, 1, 0.5))
		
		elif type == "Array":
			bg.self_modulate = Color.DARK_BLUE
			bg.self_modulate = bg.self_modulate.blend(Color(1, 1, 1, 0.5))


func _on_mouse_entered() -> void:
	entity_editor.fade_out = false
	entity_editor.cooldown_fade.start()
	
	bg.self_modulate *= 0.8
	
	if is_instance_valid(display_value):
		display_value.modulate.a = 1.0
		
		if position.x < 100:
			display_value.position.x = 64
		elif position.x > 1500:
			display_value.position.x = -320
		else:
			display_value.position.x = -display_value.size.x/2 + size.x/2 + 36
	
	var new_text_manager = Globals.scene_text_manager.instantiate()
	
	if type == "Array":
		
		new_text_manager.text_full = "[anim_rotate_around_y_fade_out]"
		new_text_manager.character_anim_speed_scale = 4
		new_text_manager.character_anim_backwards = true
		new_text_manager.cooldown_next_character = 0.01
		new_text_manager.text_animation_sync = false
		
		for x in len(property_value):
			if x != len(property_value) - 1:
				new_text_manager.text_full += str(property_value[x]) + ", "
			else:
				new_text_manager.text_full += str(property_value[x]) + "."
	else:
		new_text_manager.text_full = str(property_value)
	
	
	if is_instance_valid(display_value):
		display_value.add_child(new_text_manager)
		
		display_value_text_manager = new_text_manager
		
		display_value.visible = true


func _on_mouse_exited(delay : float = 0.0) -> void:
	bg.self_modulate *= 1.25
	
	if type == "bool" : return
	
	if not delay : display_value.modulate.a = 0.5
	
	if delay : await get_tree().create_timer(delay, true).timeout
	
	
	if is_instance_valid(display_value):
		
		display_value.visible = false
		
		for node in get_tree().get_nodes_in_group("text_manager"):
			if is_instance_valid(node) and not node.is_in_group("important") and is_instance_valid(node.get_parent().get_parent()) and not node.get_parent().get_parent().is_in_group("entity") and is_instance_valid(node.get_parent().get_parent().display_value) and not node.get_parent().get_parent().display_value.visible : node.queue_free()


func check_property_name():
	if not is_instance_valid(text_manager) : return
	
	if not property_name_active:
		property_name_active = true
		
		text_manager.text_full = "[anim_rotate_away_up_right]" + property_name
		text_manager.character_anim_speed_scale = 0.25
		text_manager.text_animation_add_offset = 0
		text_manager.cooldown_next_character = 0.01
		#text_manager.character_bg_simple = true
		text_manager.text_animation_sync = false
		text_manager.character_anim_backwards = true
		text_manager.create_message()


func apply_value():
	Globals.weapon[property_name] = property_value
	
	if Globals.random_bool(1, 9):
		Globals.message(str("Changed the behavior '%s' value to %s." % [property_name, property_value]), 0, Vector2(0, 0), 2, 4)
	else:
		Globals.message(str("Changed the behavior '%s' value to %s. Remember to press the Q key, to see how your created entity has been affected by the changes!" % [property_name, property_value]), 0, Vector2(0, randi_range(-640, 0)), 8, 12)


func _on_button_pressed() -> void:
	Globals.World.camera.override_camera_pos = Vector2.ZERO
	
	entity_editor.display_controls.visible = true
	
	$container_choices.visible = Globals.opposite_bool($container_choices.visible)
	for property_button in get_parent().get_children():
			property_button.mouse_filter = 0
			property_button.modulate = Color.WHITE


func _on_container_choices_gui_input(event: InputEvent) -> void:
	entity_editor.fade_out = false
	entity_editor.cooldown_fade.start()


func _on_btn_close_pressed() -> void:
	Globals.World.camera.override_camera_pos = Vector2.ZERO
	
	entity_editor.display_controls.visible = true
	
	$container_buttons.visible = Globals.opposite_bool($container_buttons.visible)
	for property_button in get_parent().get_children():
		property_button.mouse_filter = 0
		property_button.modulate = Color.WHITE
	
	if is_instance_valid(display_value) : display_value.visible = false


var button_affect_axis = "x"
var button_affect_position = 0

func _on_btn_toggle_x_y_pressed() -> void:
	print(type, " ", button_affect_axis)
	
	if type == "Vector2" or type == "Array":
		if button_affect_axis == "x":
			button_affect_axis = "y"
		
		elif button_affect_axis == "y":
			button_affect_axis = "x"
	
	$container_buttons/btn_toggle_x_y.text = str(button_affect_axis)


func _on_btn_change_position_pressed() -> void:
	if type == "Array":
		button_affect_position = randi_range(0, len(property_value) - 1)
	
	$container_buttons/btn_change_position.text = str(button_affect_position)
