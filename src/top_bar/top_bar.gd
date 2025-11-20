extends MarginContainer

enum FileMenu { NEW, OPEN, SAVE, SAVE_AS, QUIT }


func _ready() -> void:
	%FileMenuButton.get_popup().id_pressed.connect(_on_file_menu_selected)
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


func _on_file_menu_selected(id: int) -> void:
	match id:
		FileMenu.NEW:
			EditorManager.new_file()
		FileMenu.OPEN:
			%OpenFileDialog.show()
		FileMenu.SAVE:
			if EditorManager.is_new_file():
				%SaveFileDialog.show()
			else:
				EditorManager.save_file()
		FileMenu.SAVE_AS:
			%SaveFileDialog.show()
		FileMenu.QUIT:
			get_tree().quit()


func _on_open_file_dialog_file_selected(path: String) -> void:
	EditorManager.open_file(path)


func _on_save_file_dialog_file_selected(path: String) -> void:
	EditorManager.save_file_as(path)
