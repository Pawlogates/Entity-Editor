extends Camera2D

var speed_multiplier : float = 0.01
var target_offset : Vector2 = Vector2(0, 0)
var target_zoom : Vector2 = Vector2(1, 1)
var target_rotation : float = 0.0

@onready var color_rect: TextureRect = $ColorRect

var override_camera_pos : Vector2 = Vector2(0, 0) # Entity editor zooms in on the opened window.


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	handle_camera(delta)
	
	var color_rect_real_zoom = zoom * Vector2(1.12, 1)
	
	if abs(target_zoom.x) < 1.05 and abs(zoom.x) < 1.2:
		color_rect.scale = color_rect_real_zoom
		color_rect.position = offset + Vector2(-1105.0, 15)
	else:
		color_rect.scale = color_rect_real_zoom / 8
		color_rect.position = offset + Vector2(-820.0, 15) / 2
	
	if abs(target_offset.x) <= 10:
		color_rect.modulate.a = move_toward(color_rect.modulate.a, 0.25, delta / 12)
	else:
		color_rect.modulate.a = move_toward(color_rect.modulate.a, 1, delta / 4)
	
	if abs(zoom.x) > 1.01 and abs(zoom.x) < 2.75:
		color_rect.modulate.a = 0


func handle_camera(delta):
	offset = lerp(offset, target_offset, delta * speed_multiplier)
	zoom = lerp(zoom, target_zoom, delta * speed_multiplier)
	rotation_degrees = lerp(rotation_degrees, target_rotation, delta * speed_multiplier)
	
	speed_multiplier *= 1.1
	if speed_multiplier > 1.0 : speed_multiplier = 1.0
	
	if Globals.World.entity_editor:
		if override_camera_pos.x != 0:
			offset = override_camera_pos
			zoom = Vector2(2, 2)


func effect(camera_target_offset : Vector2 = Vector2(-1, -1), camera_target_zoom : Vector2 = Vector2(-1, -1), camera_target_rotation : float = -1, start_speed_multiplier : float = 0.01):
	if start_speed_multiplier != -1 : speed_multiplier = start_speed_multiplier
	
	if camera_target_offset != Vector2(-1, -1) : target_offset = camera_target_offset
	if camera_target_zoom != Vector2(-1, -1) : target_zoom = camera_target_zoom
	if camera_target_rotation != -1 : target_rotation = camera_target_rotation
