extends Control
class_name Exploration_GUI_Controller

@onready var place_room_menu: Control = $"../gui/place_room_menu"
@onready var animation_player: AnimationPlayer = $"../animation_player"

func display_overlay():
	place_room_menu.visible = true

func hide_overlay():
	place_room_menu.visible = false

func show_shape_out_of_bounds_message():
	animation_player.play("show_out_of_bounds_message")
	
func show_shape_covers_another_room_message():
	animation_player.play("show_covers_another_square_message")