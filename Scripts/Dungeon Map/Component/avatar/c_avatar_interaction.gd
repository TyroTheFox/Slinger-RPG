extends Node
class_name C_Avatar_Interaction

@export var player_controls_component: C_Player_Controls

@export var controls_active = true:
	set(value):
		if value:
			connect_control_events()
		else:
			disconnect_control_events()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if controls_active:
		player_controls_component.move.connect(_on_move)

func connect_control_events():
	player_controls_component.move.connect(_on_move)

func disconnect_control_events():
	player_controls_component.move.disconnect(_on_move)

func _on_move(move_x: int, move_y: int):
		get_tree().call_group("Exploration_Avatar", "move_avatar", Vector2i(move_x, move_y))

func set_control_activation(state: bool):
	controls_active = state