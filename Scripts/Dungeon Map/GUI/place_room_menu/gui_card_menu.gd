extends FoldableContainer
class_name GUI_Card_Menu

signal on_card_pressed(return_data: Dictionary)

@onready var card_space: GridContainer = $"scroll_box/card_space"

var card_list: Array[Dictionary] = []

var card_type_to_populate_with: GlobalVariables.card_type = GlobalVariables.card_type.NONE

var per_card_click_callable: Callable = func(_new_room_card): return
var per_card_build_callable: Callable = func(card_scene: Resource, _per_card_click_callable: Callable, _room_card_data: Dictionary): return card_scene.instantiate()

func set_up(_card_list: Array[Dictionary], card_type: GlobalVariables.card_type, card_click_callable: Callable, card_build_callable: Callable):
	update_card_list(_card_list)

	if !GlobalVariables.card_data.has(card_type):
		printerr("Card Type " + str(card_type) + " doesn't exist")
		return

	card_type_to_populate_with = card_type

	per_card_click_callable = card_click_callable
	per_card_build_callable = card_build_callable

func update_card_list(_card_list: Array[Dictionary]):
	card_list = _card_list

func populate_menu():
	var new_card_scene: Resource = GlobalVariables.card_data.get(card_type_to_populate_with)

	for room_card_data in card_list:
		var new_room_card: Panel = new_card_scene.instantiate()
		card_space.add_child(new_room_card)

		per_card_build_callable.call(new_room_card, per_card_click_callable, room_card_data)
		
		# new_room_card.card_text.text = room_card_data.get("name")
		# new_room_card.add_shape_to_card(room_card_data.get("colour"), room_card_data.get("name"))
		# new_room_card.card_selected.connect(per_card_click_callable.bind(new_room_card, room_card_data))

func clear_menu():
	for card in card_space.get_children():
		card.queue_free()
