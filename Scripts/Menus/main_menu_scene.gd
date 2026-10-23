extends Control
class_name Main_Menu_Scene

@export var initial_game_scene: String = ""

func _on_start_game_pressed() -> void:
	SceneManager.load_saved_scene(initial_game_scene)
