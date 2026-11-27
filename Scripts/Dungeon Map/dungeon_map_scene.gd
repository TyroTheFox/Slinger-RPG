extends Node3D
class_name Dungeon_Map_Scene

@onready var map_manager: Map_Manager = %map_manager
@onready var lookdown_camera: Camera3D = %lookdown_camera
@onready var menu: GUI_Dungeon_Map_Menu = $gui/exploration_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().call_group("Map_Avatar", "change_current_camera_state", true)
	# explore_look_camera.current = true
	map_manager.load_saved_scene("test_map")
	# get_tree().call_group("Exploration_Scene", "save_game_data")

func switch_to_lookdown_camera():
	lookdown_camera.current = true
	get_tree().call_group("Map_Avatar", "change_current_camera_state", false)

func switch_to_explore_camera():
	lookdown_camera.current = false
	get_tree().call_group("Map_Avatar", "change_current_camera_state", true)

func switch_to_place_room_mode():
	# Switch Active Control Nodes
	get_tree().call_group("Exploration_Avatar", "set_control_activation", false)
	get_tree().call_group("Exploration_GUI", "set_control_activation", true)

	get_tree().call_group("Exploration_GUI", "display_place_shape_overlay")
	
	switch_to_lookdown_camera()
	menu.hide_add_room_button()

func switch_to_use_door_card_mode(door_data: Dictionary):
	get_tree().call_group("Exploration_Avatar", "set_control_activation", false)

	get_tree().call_group("Exploration_GUI", "display_use_door_card_overlay")
	get_tree().call_group("Exploration_GUI", "set_current_door_data", door_data)

	menu.hide_add_room_button()

func switch_back_to_explore_mode():
	get_tree().call_group("Exploration_Scene", "save_game_data")

	# Switch Active Control Nodes
	get_tree().call_group("Exploration_Avatar", "set_control_activation", true)
	get_tree().call_group("Exploration_GUI", "set_control_activation", false)

	# Hide UI
	get_tree().call_group("Exploration_GUI", "_on_choice_shape_cancel")
	get_tree().call_group("Exploration_GUI", "hide_place_shape_overlay")
	get_tree().call_group("Exploration_GUI", "hide_use_door_card_overlay")

	switch_to_explore_camera()
	menu.show_add_room_button()

func update_player_position_data(current_room_id: int):
	get_tree().call_group("Exploration_GUI", "check_if_attached_to_current_room", current_room_id)
	get_tree().call_group("Exploration_Scene", "update_room_context_display", current_room_id)

	get_tree().call_group("Exploration_Scene", "update_encounter_check_values", current_room_id)
	get_tree().call_group("Exploration_Scene", "perform_encounter_checks")

func start_battle_encounter():
	get_tree().call_group("Exploration_Scene", "save_game_data")
	
	SceneManager.load_saved_scene(GlobalVariables.standard_battle_scene)