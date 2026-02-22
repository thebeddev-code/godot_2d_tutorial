extends Node

@export var mob_scene: PackedScene

var score: int


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_hud_start_game() -> void:
	new_game()


func new_game():
	$Music.play()

	# Destroy all previous entities
	get_tree().call_group("mobs", "queue_free")

	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

	$Player.start($StartPosition.position)
	# Wait for 2 seconds
	$StartTimer.start()


func game_over():
	Save.save_score(max(Save.max_score, score), score)

	$ScoreTimer.stop()
	$MobTimer.stop()

	$Music.stop()
	$DeathSound.play()

	$HUD.show_game_over()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	# After game start time passed, spawn mobs and increase score
	$MobTimer.start()
	$ScoreTimer.start()


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()

	var mob_spawn_location = $MobPath/MobSpawnLocation
	# Randomly fill the path
	mob_spawn_location.progress_ratio = randf()
	# Get point
	mob.position = mob_spawn_location.position
	# Rotate entity clockwise 90 degrees, so that it would be facing the player
	var direction = mob_spawn_location.rotation + PI / 2
	# Randomly rotate entity -+ 45 degrees
	direction += randf_range(-PI / 4, PI / 4)
	# Generate random velocity
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	# Apply rotation
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)
