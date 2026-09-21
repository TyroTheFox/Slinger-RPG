extends Control
class_name GUI_Dungeon_Map_Menu

@export var battle_scene: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	SceneManager.load_saved_scene(battle_scene)
