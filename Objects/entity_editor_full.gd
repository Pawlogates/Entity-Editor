extends Control

@onready var sfx_manager: Node2D = $sfx_manager

var fade_out = false

@onready var display_controls: ColorRect = $display_controls

@onready var entity : Node
@onready var container_property_buttons: GridContainer = $container_property_buttons

var list_behavior_name : Array = []
var d_properties_all : Dictionary


func _ready():
	await get_tree().create_timer(0.5, true).timeout
	
	container_property_buttons = $container_property_buttons
	
	#entity.sprite.sprite_frames = load(Globals.l_sprite_entity.pick_random())
	
	entity = load("res://Projectiles/fireball.tscn").instantiate()
	await get_tree().create_timer(0.5, true).timeout
	var script : GDScript = entity.get_script()
	
	for property_info in script.get_script_property_list():
		if property_info.usage & PROPERTY_USAGE_SCRIPT_VARIABLE and property_info.usage & PROPERTY_USAGE_STORAGE > 0:
			var property_name = property_info.name
			var property_value = entity.get(property_name)
			
			if property_name == "entity" : continue
			
			d_properties_all.get_or_add(property_name, property_value)
			
			print(entity.get(property_name))
			
			#if not is_instance_valid(container_property_buttons) : container_property_buttons = $container_property_buttons ; print("Unexpected behavior: property button container was somehow made invalid at some point.")
			#if Globals.random_bool(1, 100) : continue
			
			if entity.get(property_name) is bool:
				var property_button = spawn_scene(container_property_buttons, preload("res://entity_editor_button_bool.tscn"))
				property_button.property_name = property_name
				property_button.property_value = property_value
			
			elif entity.get(property_name) is float or entity.get(property_name) is int:
				var property_button = spawn_scene(container_property_buttons, preload("res://entity_editor_button_int_float.tscn"))
				property_button.property_name = property_name
				property_button.property_value = property_value
			
			elif entity.get(property_name) is String:
				var property_button = spawn_scene(container_property_buttons, preload("res://entity_editor_button_String.tscn"))
				property_button.property_name = property_name
				property_button.property_value = property_value
			
			elif entity.get(property_name) is Vector2:
				var property_button = spawn_scene(container_property_buttons, preload("res://entity_editor_button_Vector2.tscn"))
				property_button.property_name = property_name
				property_button.property_value = property_value
			
			elif entity.get(property_name) is Array:
				var property_button = spawn_scene(container_property_buttons, preload("res://entity_editor_button_Array.tscn"))
				property_button.property_name = property_name
				property_button.property_value = property_value
	
	
	SaveData.save_file(Globals.dirpath_saves + "/" + "properties.json", d_properties_all, true)
	
	for property_button in container_property_buttons.get_children():
		property_button.handle_type()
		await get_tree().create_timer(0.01, true).timeout

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("hide"):
		
		$toggle_properties_visible.visible = Globals.opposite_bool($toggle_properties_visible.visible)
		for node in Globals.World.get_children() + get_children():
			if node is Button or node is Label:
				if not node.is_in_group("important"):
					node.visible = $toggle_properties_visible.visible
		
		if Globals.World.get_node_or_null("Node2D"):
			Globals.World.get_node("Node2D").queue_free()
	
	if Input.is_action_just_pressed("quickselect"):
		container_property_buttons.visible = Globals.opposite_bool(container_property_buttons.visible)
		
		if container_property_buttons.visible:
			for node in Globals.World.get_children():
				if node is Button:
					if not node.is_in_group("important"):
						node.visible = false
		
		else:
			for node in Globals.World.get_children():
				if node is Button:
					if not node.is_in_group("important"):
						node.visible = true
		
		#for property_button in container_property_buttons.get_children():
			#property_button.check_property_name()
	
	if fade_out:
		container_property_buttons.modulate.a = move_toward(container_property_buttons.modulate.a, 0.25, delta / 10)
		display_controls.position = lerp(display_controls.position, Vector2(960, 540) - display_controls.size / 1.35, delta)
		display_controls.scale = display_controls.scale.move_toward(Vector2(1.5, 1.5), delta / 10)
		display_controls.modulate.a = move_toward(display_controls.modulate.a, 0, delta / 10)
		if not container_property_buttons.visible:
			display_controls.z_index = -999
	
	else:
		container_property_buttons.modulate.a = 1.0
		display_controls.scale = Vector2.ONE
		display_controls.position = Vector2(1554, 944)
		display_controls.modulate.a = 2
		display_controls.z_index = 10

func spawn_scene(target, scene, quantity : int = 1):
	var spawned_scenes : Array = []
	
	for x in quantity:
		var new_scene = scene.instantiate()
		target.add_child(new_scene)
		
		if quantity == 1 : return new_scene
		else : spawned_scenes.append(new_scene)
	
	return spawned_scenes


func _on_toggle_properties_visible_pressed() -> void:
	$toggle_properties_visible.position.x += 10
	
	container_property_buttons.visible = Globals.opposite_bool(container_property_buttons.visible)
	
	if container_property_buttons.visible:
		for node in Globals.World.get_children():
			if node is Button:
				print(node.get_groups())
				if not node.is_in_group("important"):
					node.visible = false
	
	else:
		for node in Globals.World.get_children():
			if node is Button:
				print(node.get_groups())
				if not node.is_in_group("important"):
					node.visible = true


@onready var cooldown_fade: Timer = $cooldown_fade

func _on_cooldown_fade_timeout() -> void:
	cooldown_fade.wait_time = randf_range(1, 4)
	fade_out = true

func _on_gui_input(event: InputEvent) -> void:
	fade_out = false
	cooldown_fade.start()
