extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("你被拿走了38w彩礼！")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	
	$Message.text = "躲避蚬钕"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$Start.show()

func update_score(score):
	$Score.text = str(score)

func _on_message_timer_timeout() -> void:
	$Message.hide()

func _on_start_pressed() -> void:
	$Start.hide()
	start_game.emit()
