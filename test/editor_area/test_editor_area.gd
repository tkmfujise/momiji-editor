extends GutTest

const Scene = preload("res://src/editor_area/editor_area.tscn")
var scene = null


func before_each():
	scene = Scene.instantiate()
	add_child_autofree(scene)


func test_ready():
	assert_not_null(scene)


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


func test_open_file():
	scene.open_file('README.md')
	assert_ne(scene.find_child('Editor').text, '')
	assert_eq(scene.file_dirty, false)
	assert_eq(scene.current_file, 'README.md')


func test_save_file_as():
	var path = 'test/fixtures/test.txt'
	scene.find_child('Editor').text = 'test'
	scene.file_dirty = true
	scene.save_file_as(path)
	assert_ne(scene.find_child('Editor').text, '')
	assert_eq(scene.file_dirty, false)
	assert_eq(scene.current_file, path)
