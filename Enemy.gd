extends CharacterBody2D

@export var moveSpeed: float = 50.0
@export var damage: float = 10.0

@onready var Player = $"/root/Main/Player"
@onready var NavAgent = $NavigationAgent2D

@onready var XP = preload("res://xp.tscn")

func _physics_process(delta):
	NavAgent.target_position = Player.position
	if !NavAgent.is_navigation_finished():
		var direction = position.direction_to(NavAgent.get_next_path_position())
		velocity = direction * moveSpeed
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func hit(player):
	player.changeHealth(-damage)
	death()

func death():
	if $"/root/Main": # needed from scene reload crash?
		$"/root/Main".add_child(XP.instantiate().fromEnemy(self))
		queue_free()
		# TODO this is just an example for playSound(), can be ripped out at any point
		Audio.playSound(preload("res://audio/sfx_debug_2.wav"))

func set_random_pos(player) -> CharacterBody2D:
	var randAngle = randi() % 360
	var radius = 350
	position = Vector2(
		clamp(sin(randAngle) * radius + player.position.x, -600, 600),
		clamp(cos(randAngle) * radius + player.position.y, -100, 450),
	)
	return self
