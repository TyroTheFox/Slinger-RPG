extends Node2D
class_name GUI_Room_Card

@onready var room_shape_space: Control = $card_ui/room_shape/room_shape_space
@onready var card_text: Label = $card_ui/description/card_text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
