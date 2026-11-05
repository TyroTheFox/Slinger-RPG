extends Node
class_name GUI_Card_Menu

@onready var card_space: GridContainer = $"../card_menu/scroll_box/card_space"
@onready var card_menu: FoldableContainer = $"../card_menu"
@onready var player_room_cards: Array[Dictionary] = PlayerManager.player_data.room_shape_cards

var card_type_to_populate_with: GlobalVariables.card_type = GlobalVariables.card_type.NONE

func set_card_type_to_populate_with(card_type: GlobalVariables.card_type):
	card_type_to_populate_with = card_type

func populate_menu(card_type: GlobalVariables.card_type):
	if !GlobalVariables.card_type.has(card_type):
		return
	
	var new_card_scene: Resource = GlobalVariables.card_type.get(card_type)

	for room_card_data in player_room_cards:
		var new_room_card = new_card_scene.instantiate()
		card_space.add_child(new_room_card)
		
		new_room_card.card_text.text = room_card_data.get("name")
		new_room_card.add_shape_to_card(room_card_data.get("colour"), room_card_data.get("name"))
		new_room_card.card_selected.connect(func():
			card_space.remove_child(new_room_card)
			get_tree().call_group("Exploration_GUI", "display_used_card", new_room_card)
			_on_room_card_pressed(room_card_data.get("id"), room_card_data.get("name"), room_card_data.get("colour"))
		)

func clear_menu():
	for card in card_space.get_children():
		card.queue_free()

func _on_card_space_folding_changed(is_folded: bool) -> void:
	if is_folded:
		clear_menu()
	else:
		player_room_cards = PlayerManager.player_data.room_shape_cards
		populate_menu(card_type_to_populate_with)

func _on_room_card_pressed(room_id: int, room_name: String, room_colour: GlobalVariables.room_colours):
	var used_room_data = PlayerManager.player_data.get_room_shape_card_by_id(room_id)

	get_tree().call_group("Exploration_GUI", "hide_card_menu")
	get_tree().call_group(
		"Exploration_GUI", "add_shape_to_interaction_space", 
		0, 0, room_colour, room_name
	)
	card_menu.folded = true
	clear_menu()
	get_tree().call_group("Exploration_GUI", "update_used_card_data", used_room_data)
	PlayerManager.player_data.remove_room_shape_card(room_id)
