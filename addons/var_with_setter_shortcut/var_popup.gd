@tool
class_name VarPopup
extends VBoxContainer

signal confirmed(var_name: String, var_type: String)

@onready var var_name: LineEdit = $VarName
@onready var var_type: LineEdit = $VarType
@onready var confirm: Button = $Confirm


func _ready() -> void:
	var_name.grab_focus()
	confirm.pressed.connect(_on_confirm_pressed)


func _gui_input(event: InputEvent) -> void:
	if ((var_name.has_focus() or var_type.has_focus()) and 
			event.is_action_pressed("ui_accept")):
		_on_confirm_pressed()


func _on_confirm_pressed() -> void:
	var fun_name := var_name.text if var_name.text else var_name.placeholder_text
	var fun_type := var_type.text if var_type.text else var_type.placeholder_text
	confirmed.emit(fun_name, fun_type)
	queue_free()
