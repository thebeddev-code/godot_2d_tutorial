extends Node

var max_score: int = 0
var last_score: int = 0

var _save_path = "user://settings.json"
var _loaded = false


func _enter_tree() -> void:
	if Save._loaded:
		printerr(
			"Error: Settings is an AutoLoad singleton and it shouldn't be instanced elsewhere."
		)
		printerr("Please delete the instance at: " + String(get_path()))
	else:
		Save._loaded = true

	if FileAccess.file_exists(_save_path):
		var file = FileAccess.open(_save_path, FileAccess.READ)
		# Check if the file cursor(in bytes) at the end of a file
		while file.get_position() < file.get_length():
			var json = JSON.new()
			# This gets a line in a file and advances the cursor
			json.parse(file.get_line())
			var data = json.get_data()

			max_score = data["max_score"]
			last_score = data["last_score"]


func save_score(new_max_score: int, new_last_score: int) -> void:
	max_score = new_max_score
	last_score = new_last_score

	var file = FileAccess.open(_save_path, FileAccess.WRITE)
	var data = {
		"max_score": new_max_score,
		"last_score": new_last_score,
	}
	file.store_line(JSON.stringify(data))
