extends Panel
class_name GUI_Room_Card

signal card_selected

const room_grid_choice_shape_scene = preload("uid://qgmsfpj4wc44")

@onready var room_shape_space: Control = $room_shape/room_shape_space
@onready var card_text: Label = $description/card_text

@export var square_width: float = 1.0
@export var square_height: float = 1.0
@export var spacing_x: float = 20.0
@export var spacing_y: float = 20.0

@export var full_grid_width = 5
@export var full_grid_height = 5 

var room_shape_instance: Room_Grid_Choice_Shape

func add_shape_to_card(colour: GlobalVariables.room_colours, shape_data_key: String) -> Room_Grid_Choice_Shape:
	if not GlobalVariables.room_shape_data.has(shape_data_key):
		return
	
	var new_shape: Room_Grid_Choice_Shape = room_grid_choice_shape_scene.instantiate()
	
	room_shape_space.add_child(new_shape)
	new_shape.set_up_shape(
		floor(full_grid_width / 2), floor(full_grid_height / 2), 
		shape_data_key,
		square_width, square_height,
		spacing_x, spacing_y,
		full_grid_width, full_grid_height
	)
	
	new_shape.room_colour = colour
	
	room_shape_instance = new_shape
	
	return new_shape

func _on_card_button_pressed() -> void:
	card_selected.emit()
