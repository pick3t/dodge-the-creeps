extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

func show_message1(text):
	$Message1.text = text
	$Message1.show()
	$MessageTimer.start()

func show_message2(text):
	$Message2.text = text
	$Message2.show()
	$MessageTimer.start()

func show_game_over(score):
	show_message1("你被拿走了" + str(score) + "w彩礼！")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	
	$Message1.text = "躲避蚬钕"
	$Message1.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$Start.show()

func update_score(score):
	$Score.text = "Score: " + str(score)

func update_life(life):
	$Life.text = "Life: " + str(life)

func _on_message_timer_timeout() -> void:
	$Message1.hide()
	$Message2.hide()

func _on_start_pressed() -> void:
	$Start.hide()
	start_game.emit()
