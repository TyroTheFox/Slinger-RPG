extends Control
class_name Exploration_GUI_Controller

@onready var place_room_menu: Control = $"place_room_menu"
@onready var card_menu: FoldableContainer = $"place_room_menu/menu/card_menu"
@onready var animation_player: AnimationPlayer = $"../animation_player"
@onready var used_card_space: Control = $"place_room_menu/used_card_space"

var used_room_card: GUI_Room_Card = null

func display_overlay():
	place_room_menu.visible = true

func hide_overlay():
	place_room_menu.visible = false

func show_shape_out_of_bounds_message():
	animation_player.play("show_out_of_bounds_message")
	
func show_shape_covers_another_room_message():
	animation_player.play("show_covers_another_square_message")

func show_card_menu():
	card_menu.visible = true

func hide_card_menu():
	card_menu.folded = true
	card_menu.visible = false

func display_used_card(used_card: GUI_Room_Card):
	used_card_space.add_child(used_card)
	used_room_card = used_card

func remove_used_card():
	used_card_space.remove_child(used_room_card)
	used_room_card.queue_free()