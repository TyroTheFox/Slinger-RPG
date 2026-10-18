extends Node
class_name GUI_C_Map_Overlay

const room_grid_square_scene = preload("uid://ch2el8blewc0m")

@export var grid_space: Control

var explortation_gui_controller: Exploration_GUI_Controller = null

func process_room_data():
	var map_room_grid = explortation_gui_controller.map_node._room_grid

	var square_width = explortation_gui_controller.square_width
	var square_height = explortation_gui_controller.square_height
	var spacing_x = explortation_gui_controller.spacing_x
	var spacing_y = explortation_gui_controller.spacing_y
	
	explortation_gui_controller.full_grid_width = map_room_grid.size()
	explortation_gui_controller.full_grid_height = map_room_grid[0].size()
	
	explortation_gui_controller.full_space_width = explortation_gui_controller.full_grid_width * (square_width + spacing_x)
	explortation_gui_controller.full_space_height = explortation_gui_controller.full_grid_height * (square_height + spacing_y)
	
	for x in explortation_gui_controller.full_grid_width:
		explortation_gui_controller.room_grid.append([])
		for y in map_room_grid[x].size():
			var grid_room: C_Room_Square = map_room_grid[x][y]
			
			if grid_room:
				var new_room_square = add_room_to_map(x, y, grid_room.room_colour)
				explortation_gui_controller.room_grid[x].push_back(new_room_square)
			else:
				var new_room_square = add_room_to_map(x, y, GlobalVariables.room_colours.NULL)
				explortation_gui_controller.room_grid[x].push_back(new_room_square)

func add_room_to_map(x: int, y: int, colour: GlobalVariables.room_colours) -> Room_Grid_Map_Square:
	var new_room: Room_Grid_Map_Square = room_grid_square_scene.instantiate()

	var full_grid_width = explortation_gui_controller.full_grid_width
	var full_grid_height = explortation_gui_controller.full_grid_height
	var square_width = explortation_gui_controller.square_width
	var square_height = explortation_gui_controller.square_height
	var spacing_x = explortation_gui_controller.spacing_x
	var spacing_y = explortation_gui_controller.spacing_y

	grid_space.add_child(new_room)
	new_room.set_up(
		x, y,
		square_width, square_height,
		spacing_x, spacing_y,
		full_grid_width, full_grid_height
	)
	
	new_room.room_colour = colour
	
	return new_room