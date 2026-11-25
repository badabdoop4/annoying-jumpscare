extends CanvasLayer

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	phonk()

func phonk() -> void:
	var target_size: Vector2i = Vector2i(get_viewport().size.x, get_viewport().size.y)
	DisplayServer.window_set_size(target_size)
	
	var screen_center: Vector2i = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	DisplayServer.window_set_position(screen_center - (target_size / 2))

	var track_number: int = rng.randi_range(1, 8)
	var audio_path: String = "res://Audio/%d.mp3" % track_number
	
	var skull_sprite: int = rng.randi_range(1, 5)
	$Skull/TextureRect.texture = load("res://Images/" + str(skull_sprite) + ".jpg")
	
	$Audio.stream = load(audio_path)
	$Audio.play()
	$Duration.start()

func interval() -> void:
	# Pass the float directly inside start() to override running state cleanly
	var next_delay: float = rng.randf_range(6.0, 10.0)
	$Random.start(next_delay) 

func _on_duration_timeout() -> void: 
	$Audio.stop()
	$Top.visible = false
	$Bottom.visible = false
	$Middle.visible = false
	$Skull.visible = false
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	interval()

func _on_random_timeout() -> void:
	$Top.visible = true
	$Bottom.visible = true
	$Middle.visible = true
	$Skull.visible = true
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	phonk()
