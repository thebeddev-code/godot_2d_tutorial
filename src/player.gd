extends Area2D

signal hit
@export var speed = 400
var screen_bounds


func _ready() -> void:
	screen_bounds = get_viewport_rect().size
	hide()


func _process(delta: float) -> void:
	var velocity: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		# Given the relationship of Hypot = sqrt(VecX^2 + VecY^2), Hypot / Hypot is 1
		# Thus any vector can be easily normalized
		velocity = velocity.normalized() * speed
		# In 60fps game, delta is usually 16ms, in say 120fps, the value is approx 8ms
		# The process method runs at delta intervals
		# By multiplying velocity, we making up for the difference in fps of different game instances
		# Thus the movement is frame-rate independent
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_bounds)

		if velocity.x != 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
		if velocity.y != 0:
			$AnimatedSprite2D.animation = "up"
			$AnimatedSprite2D.flip_v = velocity.y > 0

		$AnimatedSprite2D.play()
		return

	$AnimatedSprite2D.stop()


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	pass


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
