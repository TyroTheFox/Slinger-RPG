extends Control
class_name Main_Menu_Scene

@export var initial_game_scene: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_game_pressed() -> void:
	SceneManager.load_saved_scene(initial_game_scene)
