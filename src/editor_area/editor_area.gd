extends Control

const NEW_FILE_PLACEHOLDER = 'Untitled'
@export var EditorScene : PackedScene


func _ready() -> void:
	%Tab.set_tab_title(0, 'test')


func focus() -> void:
	if is_inside_tree(): %Tab.get_child(0).grab_focus()


func new_editor() -> void:
	var editor = EditorScene.instantiate()
	%Tab.add_child(editor)


func _on_editor_focus_entered() -> void:
	focus_entered.emit(self)


func _on_tab_tab_changed(tab: int) -> void:
	%Tab.get_child(tab).focus()


func _enter_tree() -> void:
	EditorManager.add(self)


func _exit_tree() -> void:
	EditorManager.remove(self)
