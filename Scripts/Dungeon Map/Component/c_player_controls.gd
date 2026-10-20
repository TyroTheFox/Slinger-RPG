extends Node
class_name C_Player_Controls

signal move(move_x: int, move_y: int)
signal rotate_shape(rotation_direction: Room_Grid_Choice_Shape.SHAPE_ROTATE_DIRECTION)
signal confirm_choice
signal cancel_choice

## Left Movement
@export var key_bind_left: String = "ui_left"
## Right Movement
@export var key_bind_right: String = "ui_right"
## Up Movement
@export var key_bind_up: String = "ui_up"
## Down Movement
@export var key_bind_down: String = "ui_down"
## Accept
@export var key_bind_accept: String = "ui_accept"

## Rotate Shape Left
@export var key_bind_rotate_left: String = "rotate_shape_left"
## Rotate Shape Right
@export var key_bind_rotate_right: String = "rotate_shape_right"

func _input(event: InputEvent) -> void:
	var left_pushed = event.get_action_strength(key_bind_left) > 0 
	var right_pushed = event.get_action_strength(key_bind_right) > 0
	var up_pushed = event.get_action_strength(key_bind_up) > 0
	var down_pushed = event.get_action_strength(key_bind_down) > 0
	
	var rotate_left = event.get_action_strength(key_bind_rotate_left) > 0
	var rotate_right = event.get_action_strength(key_bind_rotate_right) > 0
	
	if left_pushed and not right_pushed:
		move.emit(-1, 0)
	
	if right_pushed and not left_pushed:
		move.emit(1, 0)
	
	if up_pushed and not down_pushed:
		move.emit(0, -1)
	
	if down_pushed and not up_pushed:
		move.emit(0, 1)
	
	if rotate_left and not rotate_right:
		rotate_shape.emit(Room_Grid_Choice_Shape.SHAPE_ROTATE_DIRECTION.LEFT)
	
	if rotate_right and not rotate_left:
		rotate_shape.emit(Room_Grid_Choice_Shape.SHAPE_ROTATE_DIRECTION.RIGHT)

	if event.get_action_strength("ui_accept") > 0:
		confirm_choice.emit()

	if event.get_action_strength("ui_cancel") > 0:
		cancel_choice.emit()