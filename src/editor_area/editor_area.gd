extends Control

enum FileMenu { NEW, OPEN, SAVE, SAVE_AS, QUIT }

const NEW_FILE_PLACEHOLDER = 'Untitled'

var current_file : String
var file_dirty : bool = false


func _ready() -> void:
	%Editor.grab_focus()
	%FileMenuButton.get_popup().id_pressed.connect(_on_file_menu_selected)
	update_window_title()
	bind_file_menu_shortcuts()


func bind_file_menu_shortcuts() -> void:
	var popup = %FileMenuButton.get_popup()
	for pair in [
		['file_new',     FileMenu.NEW],
		['file_open',    FileMenu.OPEN],
		['file_save',    FileMenu.SAVE],
		['file_save_as', FileMenu.SAVE_AS],
	]:
		var shortcut = Shortcut.new()
		shortcut.events = ProjectSettings.get_setting('input/' + pair[0])['events']
		popup.set_item_shortcut(pair[1], shortcut)


func update_window_title() -> void:
	var title = \
		ProjectSettings.get_setting('application/config/name') \
		+ ' - ' + current_file_name()
	if file_dirty: title += ' *'
	get_window().title = title


func current_file_name() -> String:
	if current_file:
		return current_file.get_file()
	else:
		return NEW_FILE_PLACEHOLDER


func new_file() -> void:
	current_file = ''
	%Editor.text = ''
	file_dirty = false
	update_window_title()


func save_file():
	if current_file:
		var path = current_file
		var f = FileAccess.open(path, FileAccess.WRITE)
		f.store_string(%Editor.text)
		f.close()
		current_file = path
		file_dirty = false
		update_window_title()
	else:
		%SaveFileDialog.show()


func _on_file_menu_selected(id: int) -> void:
	match id:
		FileMenu.NEW:
			new_file()
		FileMenu.OPEN:
			%OpenFileDialog.show()
		FileMenu.SAVE:
			save_file()
		FileMenu.SAVE_AS:
			%SaveFileDialog.show()
		FileMenu.QUIT:
			get_tree().quit()


func _on_open_file_dialog_file_selected(path: String) -> void:
	var f = FileAccess.open(path, FileAccess.READ)
	%Editor.text = f.get_as_text()
	f.close()
	current_file = path
	file_dirty = false
	update_window_title()


func _on_save_file_dialog_file_selected(path: String) -> void:
	var f = FileAccess.open(path, FileAccess.WRITE)
	f.store_string(%Editor.text)
	f.close()
	current_file = path
	file_dirty = false
	update_window_title()


func _on_editor_text_changed() -> void:
	if file_dirty: return
	file_dirty = true
	update_window_title()
