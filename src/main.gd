extends Control


func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var k = event as InputEventKey
		match k.keycode:
			KEY_SPACE: %AnimatedSprite2D.play('jump')
			KEY_ENTER: %AnimatedSprite2D.play('run')
			_: %AnimatedSprite2D.play('walk')
