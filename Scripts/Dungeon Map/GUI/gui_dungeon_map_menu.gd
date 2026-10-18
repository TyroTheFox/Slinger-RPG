extends Control
class_name GUI_Dungeon_Map_Menu

@export var battle_scene: String = ""

@onready var add_room_button: Button = $add_room_button
@onready var gui_controller: Exploration_GUI_Controller = $".."

func _on_button_pressed() -> void:
	SceneManager.load_saved_scene(battle_scene)

func _on_add_room_button_pressed() -> void:
	get_tree().call_group("Dungeon_Map_Scene", "switch_to_lookdown_camera")
	# if map_manager.map_instance:
	# 	map_manager.map_instance.display_overlay()
	
	gui_controller.display_overlay()
	add_room_button.visible = false

func show_add_room_button():
	add_room_button.visible = true
