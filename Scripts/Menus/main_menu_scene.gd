extends Control
class_name Main_Menu_Scene

@export var initial_game_scene: String = ""

@onready var main_menu_screen: Control = %main_menu_screen
@onready var create_new_game_screen: Control = %create_new_game_screen
@onready var load_game_screen: Control = %load_save_screen

@onready var save_container: VBoxContainer = %save_container

func _ready() -> void:
	main_menu_screen.visible = true

func _on_start_game_pressed() -> void:
	main_menu_screen.visible = false
	create_new_game_screen.visible = true

func _on_load_game_pressed() -> void:
	main_menu_screen.visible = false

	find_and_load_game_saves()

	load_game_screen.visible = true

func _on_back_pressed() -> void:
	main_menu_screen.visible = true
	load_game_screen.visible = false
	clear_save_container()

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	SaveManager.create_game_data(new_text)
	SaveManager.save_data()
	
	SceneManager.load_saved_scene(initial_game_scene)

func find_and_load_game_saves():
	var save_file_names: PackedStringArray = SaveManager.get_all_save_data_file_names()

	if save_file_names.is_empty():
		return
	
	for file_name in save_file_names:
		var new_button: Button = Button.new()
		var just_player_name = file_name.replace(".tres", "")

		new_button.text = just_player_name

		save_container.add_child(new_button)
		new_button.pressed.connect(func(): SaveManager.load_data(file_name))

func clear_save_container():
	for child in save_container.get_children():
		save_container.remove_child(child)
		child.queue_free()