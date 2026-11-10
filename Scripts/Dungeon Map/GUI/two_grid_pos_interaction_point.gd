extends Node3D
class_name Two_Grid_Pos_Interaction_Point

@onready var ui_target: Node3D = $ui_target
@onready var gui_interaction_point: Control = $gui_space/gui_interaction_point
@onready var use_door_card_button: Button = $gui_space/gui_interaction_point/use_door_card_button

@export var ui_target_height: float = 1.5

var grid_square_pos_1: Vector3 = Vector3(0, 0, 0)
var grid_square_pos_2: Vector3 = Vector3(0, 0, 0)

var door_data: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	use_door_card_button.pressed.connect(_on_use_door_card_button_pressed)

func set_up(pos_1: Vector3, pos_2: Vector3, data: Dictionary):
	grid_square_pos_1 = pos_1
	grid_square_pos_2 = pos_2

	door_data = data

	# Regards the XZ axis as akin to a XY axis except on the floor, with Y as the set height of the floor
	var width = grid_square_pos_1.x - grid_square_pos_2.x
	var height = grid_square_pos_1.z - grid_square_pos_2.z

	var half_x = grid_square_pos_1.x - (width * 0.5)
	var half_y = grid_square_pos_1.z - (height * 0.5)

	ui_target.position.x = half_x
	ui_target.position.y = ui_target_height
	ui_target.position.z = half_y

func _on_use_door_card_button_pressed() -> void:
	pass # Replace with function body.

func set_gui_space_visibility(_visible: bool) -> void:
	gui_interaction_point.visible = _visible