extends GutTest

const Editor = preload("res://src/editor_area/editor_area.tscn")
var editor = null


func before_each():
	editor = Editor.instantiate()


func after_each():
	if editor: editor.queue_free()


func set_current(node: Node):
	add_child_autofree(editor)
	EditorManager.current = node


func test_focus_first():
	EditorManager.focus_first()
	assert_eq(EditorManager.current, null)
	add_child_autofree(editor)
	EditorManager.focus_first()
	assert_eq(EditorManager.current, editor)


func test_add():
	EditorManager.add(editor)
	assert_gt(EditorManager.all.find(editor), -1)


func test_remove():
	EditorManager.remove(editor)
	assert_engine_error(0)
	EditorManager.add(editor)
	EditorManager.remove(editor)
	assert_eq(EditorManager.all.find(editor), -1)


func test_new_file():
	set_current(editor)
	EditorManager.new_file()
	assert_engine_error(0)


func test_is_new_file():
	set_current(editor)
	editor.current_file = ''
	assert_eq(EditorManager.is_new_file(), true)
	editor.current_file = 'foo/bar.gd'
	assert_eq(EditorManager.is_new_file(), false)


func test_open_file():
	set_current(editor)
	EditorManager.open_file('README.md')
	assert_engine_error(0)


func test_save_file():
	set_current(editor)
	EditorManager.save_file()
	var path = 'test/fixtures/empty.txt'
	editor.current_file = path
	EditorManager.save_file()
	assert_engine_error(0)


func test_save_file_as():
	set_current(editor)
	var path = 'test/fixtures/empty.txt'
	editor.current_file = path
	EditorManager.save_file_as(path)
	assert_engine_error(0)
