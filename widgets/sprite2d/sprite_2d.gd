extends Node2D

const MAX_HEIGHT = 1080


func _ready() -> void:
	get_viewport().size_changed.connect(_on_size_changed)


func _on_size_changed() -> void:
	var height = get_viewport().size.y
	scale = Vector2(1, 1) * height * 2 / (MAX_HEIGHT * ProjectSettings.get('display/window/stretch/scale'))


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var k = event as InputEventKey
		match k.keycode:
			KEY_SPACE: %AnimatedSprite2D.play('jump')
			KEY_ENTER: %AnimatedSprite2D.play('run')
			_: %AnimatedSprite2D.play('walk')
