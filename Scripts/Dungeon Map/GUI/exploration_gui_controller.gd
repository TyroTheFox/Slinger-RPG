extends Control
class_name Exploration_GUI_Controller

@onready var place_room_menu: Control = $"../gui/place_room_menu"

func display_overlay():
	place_room_menu.visible = true

func hide_overlay():
	place_room_menu.visible = false
