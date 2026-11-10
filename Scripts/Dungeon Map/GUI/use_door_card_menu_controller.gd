extends Control
class_name Use_Door_Card_Menu_Controller

@onready var card_menu: GUI_Card_Menu = $door_card_menu
@onready var player_room_context_cards: Array[Dictionary] = PlayerManager.player_data.room_context_cards

var context_room_on_press_callable: Callable = func(new_room_card, room_card_data: Dictionary):
	card_menu.card_space.remove_child(new_room_card)
	get_tree().call_group("Exploration_GUI", "display_used_card", new_room_card)
	card_menu.on_card_pressed.emit({
		"id": room_card_data.get("id"),
		"name": room_card_data.get("name")
	})

func _ready() -> void:
	card_menu.set_up(player_room_context_cards, GlobalVariables.card_type.ROOM_CONTEXT, context_room_on_press_callable)
	card_menu.on_card_pressed.connect(_on_room_card_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_room_card_pressed(return_data: Dictionary):
	pass