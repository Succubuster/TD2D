extends Node2D

@onready var Enemy = preload("res://enemy.tscn")
func _ready():
	create_tween().set_loops().tween_callback(
		func ():
			add_child(Enemy.instantiate())
	).set_delay(1)
