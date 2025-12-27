@tool
class_name FunctionPopup
extends VBoxContainer

signal confirmed(function_name: String, function_type: String)

@onready var function_name: LineEdit = $FunctionName
@onready var function_type: LineEdit = $FunctionType
@onready var confirm: Button = $Confirm


func _ready() -> void:
	function_name.grab_focus()
	confirm.pressed.connect(_on_confirm_pressed)


func _gui_input(event: InputEvent) -> void:
	if ((function_name.has_focus() or function_type.has_focus()) and 
			event.is_action_pressed("ui_accept")):
		_on_confirm_pressed()


func _on_confirm_pressed() -> void:
	var fun_name := function_name.text if function_name.text else function_name.placeholder_text
	var fun_type := function_type.text if function_type.text else function_type.placeholder_text
	confirmed.emit(fun_name, fun_type)
	queue_free()
