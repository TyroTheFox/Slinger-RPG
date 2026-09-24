extends CanvasLayer
class_name Loading_Screen

signal loading_screen_ready

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $Panel/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await animation_player.animation_finished
	loading_screen_ready.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_progress_changed(new_value: float) -> void:
	progress_bar.value = new_value

func _on_load_finished() -> void:
	animation_player.play_backwards("transition")
	await animation_player.animation_finished
	queue_free()
