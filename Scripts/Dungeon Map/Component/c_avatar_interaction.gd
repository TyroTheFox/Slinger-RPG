extends Node
class_name C_Avatar_Interaction

@export var room_grid_controls_component: C_Player_Controls

var active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_grid_controls_component.move.connect(_on_move)

func _on_move(move_x: int, move_y: int):
	if active:
		get_tree().call_group("Exploration_Scene_Event", "move_avatar", Vector2i(move_x, move_y))
