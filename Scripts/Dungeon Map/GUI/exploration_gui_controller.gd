extends Control
class_name Exploration_GUI_Controller

@onready var place_room_menu: Control = $"place_room_menu"
@onready var card_menu: FoldableContainer = $"place_room_menu/menu/card_menu"
@onready var animation_player: AnimationPlayer = $"../animation_player"
@onready var used_card_space: Control = $"place_room_menu/used_card_space"
@onready var map_manager: Map_Manager = %map_manager

@export var map_overlay_gui_component: GUI_C_Map_Overlay
@export var choice_space_gui_component: GUI_C_Choice_Space
@export var map_interaction_gui_component: GUI_C_Map_Interaction

var map_node: C_Exploration_Map = null

var room_grid: Array[Array] = []

# Square Data
@export var square_width: float = 30.0
@export var square_height: float = 30.0
@export var spacing_x: float = 1.0
@export var spacing_y: float = 1.0

var full_grid_width: int = 0
var full_grid_height: int = 0

var full_space_width: float = 0
var full_space_height: float = 0

# Choice Space
var interaction_shape: Room_Grid_Choice_Shape = null

# Used Room Card
var used_room_card: GUI_Room_Card = null
var used_card_data: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_overlay_gui_component.explortation_gui_controller = self
	choice_space_gui_component.explortation_gui_controller = self
	map_interaction_gui_component.explortation_gui_controller = self

	map_manager.load_finished.connect(
		func(map_instance: C_Exploration_Map): 
			map_node = map_instance
			map_overlay_gui_component.process_room_data()
	)

func display_overlay():
	place_room_menu.visible = true

func hide_overlay():
	place_room_menu.visible = false

func show_shape_out_of_bounds_message():
	animation_player.play("show_out_of_bounds_message")
	
func show_shape_covers_another_room_message():
	animation_player.play("show_covers_another_square_message")

func show_shape_not_next_to_traversable_room():
	animation_player.play("show_shape_not_adjacent_to_traversable_room_message")

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
	used_card_data = {}

func update_used_card_data(data: Dictionary):
	used_card_data = data
