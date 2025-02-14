extends CanvasLayer

signal start
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	$MessageTimer.start()
	$Title.text = "Get ready..."
	$StartButton.hide()
		
func _on_message_timer_timeout() -> void:
	$Title.hide()
	start.emit()
