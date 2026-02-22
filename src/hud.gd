extends CanvasLayer

signal start_game
@onready var score_label = $ScoreLabel
@onready var message_timer = $MessageTimer
@onready var game_message = $Message
@onready var start_button = $StartButton
@onready var score_stats = $ScoreStats


func _ready() -> void:
	score_label.hide()
	update_score_stats()


func update_score(score):
	score_label.text = str(score)


func update_score_stats():
	score_stats.text = "Max score: {0}\nLast score: {1}".format([Save.max_score, Save.last_score])


func show_message(text):
	game_message.text = text
	game_message.show()
	message_timer.start()


func _on_message_timer_timeout() -> void:
	game_message.hide()
	pass


func show_game_over():
	update_score_stats()

	show_message("Game over")
	update_score(0)
	score_label.hide()

	await message_timer.timeout

	game_message.text = "Dodge the Creeps!"
	game_message.show()
	start_button.show()


func _on_start_button_pressed() -> void:
	start_button.hide()
	game_message.hide()
	score_label.show()
	start_game.emit()
