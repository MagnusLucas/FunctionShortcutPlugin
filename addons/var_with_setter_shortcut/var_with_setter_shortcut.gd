@tool
extends EditorPlugin

const VAR_POPUP = preload("uid://b7s0oaaq1b2wp")

var var_shortcut: Shortcut

func _enter_tree() -> void:
	var_shortcut = Shortcut.new()
	var key_event = InputEventKey.new()
	key_event.keycode = KEY_E
	key_event.ctrl_pressed = true
	key_event.shift_pressed = true
	key_event.command_or_control_autoremap = true
	var_shortcut.events = [key_event]


func _exit_tree() -> void:
	var_shortcut = null


func _input(event: InputEvent) -> void:
	if !var_shortcut:
		return
	if var_shortcut.matches_event(event) and event.is_pressed() and not event.is_echo():
		var editor := EditorInterface.get_script_editor().get_current_editor()
		var popup := VAR_POPUP.instantiate()
		editor.add_child(popup)
		popup.confirmed.connect(_handle_confirmation)
		get_viewport().set_input_as_handled()


func _handle_confirmation(var_name: String, var_type: String) -> void:
	var editor := EditorInterface.get_script_editor().get_current_editor()
	var code_edit: CodeEdit = editor.find_child("*CodeEdit*", true, false)
	
	var text := (
		"var " + var_name + ": " + var_type + ": set = _set_" + var_name + "


func _set_" + var_name + "(value: " + var_type + ") -> void:
	"  + var_name + " = value")
	
	var undoredo := get_undo_redo()
	undoredo.create_action("insert " + var_name + " variable with setter")
	
	# DO
	undoredo.add_do_method(code_edit, "insert_text_at_caret", text)
	undoredo.add_do_method(code_edit, "grab_focus")
	
	# UNDO
	undoredo.add_undo_method(code_edit, "undo")
	undoredo.add_undo_method(code_edit, "grab_focus")
	undoredo.commit_action()
