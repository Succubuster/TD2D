extends CharacterBody2D

@export var moveSpeed: float = 100.0

func _physics_process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity.x = -moveSpeed
	if Input.is_action_pressed("ui_right"):
		velocity.x = moveSpeed
	if Input.is_action_pressed("ui_down"):
		velocity.y = moveSpeed
	if Input.is_action_pressed("ui_up"):
		velocity.y = -moveSpeed
	move_and_slide()
