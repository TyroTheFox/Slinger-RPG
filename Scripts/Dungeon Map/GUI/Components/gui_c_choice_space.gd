extends Node
class_name GUI_C_Choice_Space

const room_grid_choice_shape_scene = preload("uid://qgmsfpj4wc44")

@export var interaction_space: Control

var explortation_gui_controller: Exploration_GUI_Controller = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_shape_to_interaction_space(x: int, y: int, colour: GlobalVariables.room_colours, shape_data_key: String) -> Room_Grid_Choice_Shape:
	if not GlobalVariables.room_shape_data.has(shape_data_key):
		return
	
	var new_shape: Room_Grid_Choice_Shape = room_grid_choice_shape_scene.instantiate()
	
	interaction_space.add_child(new_shape)
	new_shape.set_up_shape(
		x, y, 
		shape_data_key,
		explortation_gui_controller.square_width, explortation_gui_controller.square_height,
		explortation_gui_controller.spacing_x, explortation_gui_controller.spacing_y,
		explortation_gui_controller.full_grid_width, explortation_gui_controller.full_grid_height
	)
	
	new_shape.room_colour = colour
	
	explortation_gui_controller.interaction_shape = new_shape
	
	return new_shape

func remove_shape_from_interaction_space():
	if not explortation_gui_controller.interaction_shape:
		return
	
	explortation_gui_controller.interaction_shape.queue_free()
	explortation_gui_controller.interaction_shape = null