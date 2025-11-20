extends GutTest

const Scene = preload("res://src/top_bar/top_bar.tscn")
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



func test_on_open_file_dialog_file_selected():
	scene._on_open_file_dialog_file_selected('README.md')
	assert_engine_error(0)


func test_on_save_file_dialog_file_selected():
	var path = 'test/fixtures/empty.txt'
	scene._on_save_file_dialog_file_selected(path)
	assert_engine_error(0)


func test_on_file_menu_selected():
	scene._on_file_menu_selected(FileMenu.NEW)
	scene._on_file_menu_selected(FileMenu.OPEN)
	scene._on_file_menu_selected(FileMenu.SAVE)
	scene._on_file_menu_selected(FileMenu.SAVE_AS)
	scene._on_file_menu_selected(FileMenu.QUIT)
	assert_engine_error(0)
