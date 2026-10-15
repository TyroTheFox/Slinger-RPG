extends Node
class_name GUI_Card_Menu

const room_card_scene = preload("uid://bx7rqr7nfs1p5")

@onready var card_space: HFlowContainer = $"../card_menu/card_space"
@onready var player_room_cards: Array[Dictionary] = PlayerManager.player_data.room_cards

func populate_menu():
	for room_card_data in player_room_cards:
		var new_room_card: GUI_Room_Card = room_card_scene.instantiate()
		card_space.add_child(new_room_card)
		
		new_room_card.card_text.text = room_card_data.get("name")
	
	card_space.queue_sort()

func clear_menu():
	for card in card_space.get_children():
		card.queue_free()

func _on_card_space_folding_changed(is_folded: bool) -> void:
	if is_folded:
		clear_menu()
	else:
		player_room_cards = PlayerManager.player_data.room_cards
		populate_menu()
