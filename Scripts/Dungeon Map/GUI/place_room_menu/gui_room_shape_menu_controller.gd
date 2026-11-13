extends Node
class_name GUI_Room_Shape_Menu_Controller

@onready var card_menu: GUI_Card_Menu = $"../card_menu"
@onready var player_room_shape_cards: Array[Dictionary] = PlayerManager.player_data.room_shape_cards

var shape_room_on_press_callable: Callable = func(new_room_card, room_card_data: Dictionary):
	card_menu.card_space.remove_child(new_room_card)
	get_tree().call_group("Exploration_GUI", "display_used_card", new_room_card)
	card_menu.on_card_pressed.emit({
		"id": room_card_data.get("id"),
		"name": room_card_data.get("name"),
		"colour": room_card_data.get("colour")
	})

var shape_room_card_build_callable: Callable = func(new_room_card: Panel, per_card_click_callable: Callable, room_card_data: Dictionary):
	new_room_card.card_text.text = room_card_data.get("name")
	new_room_card.add_shape_to_card(room_card_data.get("colour"), room_card_data.get("name"))
	new_room_card.card_selected.connect(per_card_click_callable.bind(new_room_card, room_card_data))

func _ready() -> void:
	card_menu.set_up(player_room_shape_cards, GlobalVariables.card_type.ROOM_SHAPE, shape_room_on_press_callable, shape_room_card_build_callable)
	card_menu.on_card_pressed.connect(_on_room_card_pressed)

func populate_menu():
	card_menu.update_card_list(player_room_shape_cards)
	card_menu.populate_menu()

func clear_menu():
	card_menu.clear_menu()

func _on_card_space_folding_changed(is_folded: bool) -> void:
	if is_folded:
		clear_menu()
	else:
		player_room_shape_cards = PlayerManager.player_data.room_shape_cards
		populate_menu()

func _on_room_card_pressed(return_data: Dictionary):
	var room_id: int = return_data.id
	var room_name: String = return_data.name
	var room_colour: GlobalVariables.room_colours = return_data.colour

	var used_room_data = PlayerManager.player_data.get_room_shape_card_by_id(room_id)

	hide_card_menu()
	get_tree().call_group(
		"Exploration_GUI", "add_shape_to_interaction_space", 
		0, 0, room_colour, room_name
	)
	clear_menu()
	get_tree().call_group("Exploration_GUI", "update_used_card_data", used_room_data)
	PlayerManager.player_data.remove_room_shape_card(room_id)

func show_card_menu():
	card_menu.visible = true

func hide_card_menu():
	card_menu.folded = true
	card_menu.visible = false
