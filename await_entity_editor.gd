extends Node2D

var scene_filepath = Globals.scene_entity_editor


func _ready() -> void:
	pass
	#Globals.gameState_changed.connect(check)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("map"):
		check(true)


func check(instant : bool = false):
	#if Globals.gameState_levelSet_screen or Globals.gameState_start_screen:
		#if not len(get_tree().get_nodes_in_group("entity_editor")) : return
		#if not has_node("./" + "entity_editor") : return
		#
		#Overlay.HUD.animation_player.play("hide")
	
	#if Globals.gameState_level or Globals.World.entity_editor:
	#if not instant : await get_tree().create_timer(5.0, true).timeout
	#if len(get_tree().get_nodes_in_group("entity_editor")) : return
	#if has_node("./" + "entity_editor") : return
	var instance = load(scene_filepath).instantiate()
	Overlay.add_child(instance)
	Overlay.reassign_general()
	Globals.dm("Added an entity_editor to the scene tree.")
