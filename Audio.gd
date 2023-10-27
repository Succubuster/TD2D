extends Node2D
## Audio manager for quick & easy audio playback. Use as an Autoload.


## node2d of any type which the audio manager positions the listener to
var listenerTarget : Node2D
## manual listener node so that positional sound accurately pans/rolls off
var listener : AudioListener2D


## create listener at runtime since this is an autoload
func _ready() -> void:
	listener = AudioListener2D.new()
	add_child(listener)


## manually position listner at desired target, as long as target exists
func _physics_process(_delta: float) -> void:
	if is_instance_valid(listenerTarget):
		listener.global_position = listenerTarget.global_position


## basic setup for one-shot audio player
func _createSoundPlayer(audioStream : AudioStream) -> AudioStreamPlayer2D:
	var audioPlayer = AudioStreamPlayer2D.new()
	audioPlayer.stream = audioStream
	audioPlayer.finished.connect(func(): audioPlayer.queue_free())
	return audioPlayer


## play sound 'globally' (directly on the listener)
func playSound(audioStream : AudioStream) -> AudioStreamPlayer2D:
	var audioPlayer = _createSoundPlayer(audioStream)
	listener.add_child(audioPlayer)
	audioPlayer.play()
	return audioPlayer


## play sound at given position
func playSoundAt(audioStream : AudioStream, pos : Vector2) -> AudioStreamPlayer2D:
	var audioPlayer = _createSoundPlayer(audioStream)
	add_child(audioPlayer)
	audioPlayer.global_position = pos
	audioPlayer.play()
	return audioPlayer


## play sound from a given node's position (does NOT automatically follow the node while playing)
func playSoundFrom(audioStream : AudioStream, target : Node2D) -> AudioStreamPlayer2D:
	return playSoundAt(audioStream, target.global_position)
