extends Control


func _ready() -> void:
	$ButtonList/StartButton.pressed.connect(_onStartPressed)
	$ButtonList/SettingsButton.pressed.connect(_onSettingsPressed)
	$ButtonList/QuitButton.pressed.connect(_onQuitPressed)
	$ButtonList/StartButton.grab_focus()


func _onStartPressed():
	 # TODO consider changing 'main.tscn's name to something more specific, like 'game' or 'level'?
	get_tree().change_scene_to_file('res://main.tscn')


func _onSettingsPressed():
	# TODO placeholder because we don't have a settings system implemented yet, but once we do, I
	# think we should make a separate scene for the settings menu & instantiate it here
	pass


func _onQuitPressed():
	get_tree().quit()
