extends Control

const NEW_FILE_PLACEHOLDER = 'Untitled'

var file_dirty : bool = false
var current_file : String


func focus() -> void:
	if is_inside_tree(): %Editor.grab_focus()


func current_file_name() -> String:
	if current_file:
		return current_file.get_file()
	else:
		return NEW_FILE_PLACEHOLDER


func new_file() -> void:
	current_file = ''
	%Editor.text = ''
	file_dirty = false


func is_new_file() -> bool:
	return current_file.is_empty()


func save_file():
	if current_file:
		var path = current_file
		var f = FileAccess.open(path, FileAccess.WRITE)
		f.store_string(%Editor.text)
		f.close()
		current_file = path
		file_dirty = false
	else:
		pass


func open_file(path: String) -> void:
	var f = FileAccess.open(path, FileAccess.READ)
	%Editor.text = f.get_as_text()
	f.close()
	current_file = path
	file_dirty = false


func save_file_as(path: String) -> void:
	var f = FileAccess.open(path, FileAccess.WRITE)
	f.store_string(%Editor.text)
	f.close()
	current_file = path
	file_dirty = false


func _on_editor_text_changed() -> void:
	if file_dirty: return
	file_dirty = true


func _on_editor_focus_entered() -> void:
	focus_entered.emit(self)


func _enter_tree() -> void:
	EditorManager.add(self)


func _exit_tree() -> void:
	EditorManager.remove(self)
