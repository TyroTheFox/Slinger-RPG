extends Control
class_name Use_Door_Card_Menu_Controller

@onready var card_menu: GUI_Card_Menu = $door_card_menu
@onready var player_room_context_cards: Array[Dictionary] = PlayerManager.player_data.room_context_cards

var current_door_data = {}

var context_room_on_press_callable: Callable = func(new_room_card, room_card_data: Dictionary):
	card_menu.card_space.remove_child(new_room_card)
	# get_tree().call_group("Exploration_GUI", "display_used_card", new_room_card)
	card_menu.on_card_pressed.emit({
		"id": room_card_data.get("id"),
		"name": room_card_data.get("name")
	})

var context_room_card_build_callable: Callable = func(new_room_card: Panel, per_card_click_callable: Callable, room_card_data: Dictionary):
	new_room_card.title_label.text = room_card_data.get("name")
	new_room_card.card_selected.connect(per_card_click_callable.bind(new_room_card, room_card_data))

func _ready() -> void:
	card_menu.set_up(player_room_context_cards, GlobalVariables.card_type.ROOM_CONTEXT, context_room_on_press_callable, context_room_card_build_callable)
	card_menu.on_card_pressed.connect(_on_room_card_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func populate_menu():
	card_menu.update_card_list(player_room_context_cards)
	card_menu.populate_menu()

func clear_menu():
	card_menu.clear_menu()

func _on_door_card_menu_folding_changed(is_folded: bool) -> void:
	if is_folded:
		clear_menu()
	else:
		player_room_context_cards = PlayerManager.player_data.room_context_cards
		populate_menu()

func _on_room_card_pressed(return_data: Dictionary):
	pass

func on_door_button_pressed(door_data: Dictionary):
	current_door_data = door_data
	get_tree().call_group("Exploration_Avatar", "set_control_activation", false)

	self.visible = true
	card_menu.expand()

func _on_close_menu_button_pressed() -> void:
	current_door_data = {}
	get_tree().call_group("Exploration_Avatar", "set_control_activation", true)

	self.visible = false
	card_menu.fold()
