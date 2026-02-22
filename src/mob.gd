extends RigidBody2D


func _ready() -> void:
	# Since all animations feature unique mob
	# We pick a random one to generate a random mob
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Destroy once outside the visible area
	queue_free()
