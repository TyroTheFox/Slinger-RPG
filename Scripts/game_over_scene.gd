extends Control
class_name Game_Over_Scene

@export var try_again_scene: String = ""
@export var main_menu_scene: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_try_again_pressed() -> void:
	SceneManager.load_saved_scene(try_again_scene)


func _on_main_menu_pressed() -> void:
	SceneManager.load_saved_scene(main_menu_scene)
