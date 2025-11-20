extends Node

var all : Array[Node]
var current : Node


func focus_first() -> void:
	if all.is_empty(): return
	var editor = all.filter(func(n): return n != null)
	if editor: editor[0].focus()


func add(editor: Node) -> void:
	all.push_back(editor)
	editor.focus_entered.connect(_editor_focused)


func remove(editor: Node) -> void:
	var idx = all.find(editor)
	if idx >= 0: all.remove_at(idx)


func new_file() -> void:
	if current: current.new_file()


func is_new_file() -> bool:
	if not current: return false
	return current.is_new_file()


func open_file(path: String) -> void:
	if current: current.open_file(path)


func save_file() -> void:
	if current: current.save_file()


func save_file_as(path: String) -> void:
	if current: current.save_file_as(path)


func _editor_focused(editor: Node) -> void:
	current = editor
