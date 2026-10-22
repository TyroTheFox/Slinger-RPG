extends Node3D
class_name Dungeon_Map_Scene

@onready var map_manager: Map_Manager = $map_manager
@onready var lookdown_camera: Camera3D = $lookdown_camera
@onready var explore_look_camera: Camera3D = $explore_look_camera
@onready var menu: GUI_Dungeon_Map_Menu = $gui/exploration_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explore_look_camera.current = true
	map_manager.load_saved_scene("test_map")

func switch_to_lookdown_camera():
	lookdown_camera.current = true
	explore_look_camera.current = false

func switch_to_explore_camera():
	lookdown_camera.current = false
	explore_look_camera.current = true

func switch_to_place_room_mode():
	# Switch Active Control Nodes
	get_tree().call_group("Exploration_Avatar", "set_control_activation", false)
	get_tree().call_group("Exploration_GUI", "set_control_activation", true)

	get_tree().call_group("Exploration_GUI", "display_overlay")

	switch_to_lookdown_camera()
	menu.hide_add_room_button()

func switch_back_to_explore_mode():
	# Switch Active Control Nodes
	get_tree().call_group("Exploration_Avatar", "set_control_activation", true)
	get_tree().call_group("Exploration_GUI", "set_control_activation", false)

	# Hide UI
	get_tree().call_group("Exploration_GUI", "_on_choice_shape_cancel")
	get_tree().call_group("Exploration_GUI", "hide_overlay")

	switch_to_explore_camera()
	menu.show_add_room_button()
