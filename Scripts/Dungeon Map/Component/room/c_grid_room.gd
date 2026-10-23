extends Node
class_name C_Grid_Room

var grid_x: int = 0
var grid_y: int = 0
var grid_z: int = 0

var north_cell: C_Grid_Room = null
var east_cell: C_Grid_Room = null
var west_cell: C_Grid_Room = null
var south_cell: C_Grid_Room = null

var room_colour: GlobalVariables.room_colours = GlobalVariables.room_colours.NULL
