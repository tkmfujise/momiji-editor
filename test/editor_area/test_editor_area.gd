extends GutTest

const Scene = preload("res://src/editor_area/editor_area.tscn")
var scene = null

enum FileMenu { NEW, OPEN, SAVE, SAVE_AS, QUIT }


func before_each():
	scene = Scene.instantiate()
	add_child_autofree(scene)


func test_ready():
	assert_not_null(scene)
	assert_eq(scene.find_child('OpenFileDialog').visible, false)
	assert_eq(scene.find_child('SaveFileDialog').visible, false)


func test_bind_file_menu_shortcuts():
	var popup = scene.find_child('FileMenuButton').get_popup()
	assert_not_null(popup)
	assert_not_null(popup.get_item_shortcut(FileMenu.NEW))
	assert_not_null(popup.get_item_shortcut(FileMenu.OPEN))
	assert_not_null(popup.get_item_shortcut(FileMenu.SAVE))
	assert_not_null(popup.get_item_shortcut(FileMenu.SAVE_AS))


func test_update_window_title_new_file():
	scene.update_window_title()
	assert_eq(get_window().title, 'MomijiEditor - Untitled')
	scene.file_dirty = true
	scene.update_window_title()
	assert_eq(get_window().title, 'MomijiEditor - Untitled *')


func test_update_window_title_existing_file():
	scene.current_file = 'foo/bar.rb'
	scene.update_window_title()
	assert_eq(get_window().title, 'MomijiEditor - bar.rb')
	scene.file_dirty = true
	scene.update_window_title()
	assert_eq(get_window().title, 'MomijiEditor - bar.rb *')


func test_new_file():
	scene.new_file()
	assert_eq(scene.find_child('Editor').text, '')
	assert_eq(scene.file_dirty, false)
	assert_eq(scene.current_file, '')


func test_save_file_new():
	scene.save_file()
	assert_engine_error(0)


func test_save_file_existing():
	scene.current_file = 'test/fixtures/empty.txt'
	scene.file_dirty = true
	scene.save_file()
	assert_eq(scene.file_dirty, false)


func test_on_open_file_dialog_file_selected():
	scene._on_open_file_dialog_file_selected('README.md')
	assert_ne(scene.find_child('Editor').text, '')
	assert_eq(scene.file_dirty, false)
	assert_eq(scene.current_file, 'README.md')


func test_on_save_file_dialog_file_selected():
	var path = 'test/fixtures/test.txt'
	scene.find_child('Editor').text = 'test'
	scene.file_dirty = true
	scene._on_save_file_dialog_file_selected(path)
	assert_ne(scene.find_child('Editor').text, '')
	assert_eq(scene.file_dirty, false)
	assert_eq(scene.current_file, path)


func test_on_file_menu_selected():
	scene._on_file_menu_selected(FileMenu.NEW)
	scene._on_file_menu_selected(FileMenu.OPEN)
	scene._on_file_menu_selected(FileMenu.SAVE)
	scene._on_file_menu_selected(FileMenu.SAVE_AS)
	scene._on_file_menu_selected(FileMenu.QUIT)
	assert_engine_error(0)
