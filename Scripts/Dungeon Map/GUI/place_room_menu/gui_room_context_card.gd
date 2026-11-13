extends Panel
class_name GUI_Room_Context_Card

signal card_selected

@onready var title_label: Label = $title_label
@onready var effect_label: Label = $effect_label

func _on_card_button_pressed() -> void:
	card_selected.emit()
