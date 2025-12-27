@tool
extends EditorPlugin

const FUNCTION_POPUP = preload("uid://btgsopoj31lnb")

var func_shortcut: Shortcut

func _enter_tree() -> void:
	func_shortcut = Shortcut.new()
	var key_event = InputEventKey.new()
	key_event.keycode = KEY_E
	key_event.ctrl_pressed = true
	key_event.command_or_control_autoremap = true
	func_shortcut.events = [key_event]


func _exit_tree() -> void:
	func_shortcut = null


func _input(event: InputEvent) -> void:
	if !func_shortcut:
		return
	if func_shortcut.matches_event(event) and event.is_pressed() and not event.is_echo():
		var editor := EditorInterface.get_script_editor().get_current_editor()
		var popup := FUNCTION_POPUP.instantiate()
		editor.add_child(popup)
		popup.confirmed.connect(_handle_confirmation)
		get_viewport().set_input_as_handled()


func _handle_confirmation(function_name: String, function_type: String) -> void:
	var editor := EditorInterface.get_script_editor().get_current_editor()
	var code_edit: CodeEdit = editor.find_child("*CodeEdit*", true, false)
	
	var text := "

func " + function_name + "() -> " + function_type + ":
	pass
"
	var bracket_position := text.find("(") - 2
	var undoredo := get_undo_redo()
	undoredo.create_action("insert empty " + function_name + " function")
	
	# DO
	undoredo.add_do_method(code_edit, "insert_text_at_caret", text)
	undoredo.add_do_method(code_edit, "set_caret_line", code_edit.get_caret_line() + 2)
	undoredo.add_do_method(code_edit, "set_caret_column", bracket_position + 1)
	undoredo.add_do_method(code_edit, "grab_focus")
	
	# UNDO
	undoredo.add_undo_method(code_edit, "undo")
	undoredo.add_undo_method(code_edit, "grab_focus")
	undoredo.commit_action()
