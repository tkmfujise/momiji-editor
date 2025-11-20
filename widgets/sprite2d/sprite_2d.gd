extends Node2D

const MAX_WIDTH = 1080


func _ready() -> void:
	get_viewport().size_changed.connect(_on_size_changed)


func _on_size_changed() -> void:
	var width = get_viewport().size.x
	scale = Vector2(1, 1) * width / (MAX_WIDTH * ProjectSettings.get('display/window/stretch/scale'))


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var k = event as InputEventKey
		match k.keycode:
			KEY_SPACE: %AnimatedSprite2D.play('jump')
			KEY_ENTER: %AnimatedSprite2D.play('run')
			_: %AnimatedSprite2D.play('walk')
