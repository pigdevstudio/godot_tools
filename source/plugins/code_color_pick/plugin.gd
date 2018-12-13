tool
extends EditorPlugin

func _ready():
	get_editor_interface().get_script_editor().connect("editor_script_changed",
			self, "_on_editor_script_changed")
			
	find_text_editor(get_editor_interface().get_script_editor())

func _on_editor_script_changed(new_script):
	find_text_editor(get_editor_interface().get_script_editor())

func _on_cursor_changed(text_edit):
	var line = text_edit.get_line(text_edit.cursor_get_line())
	
	if line.ends_with("Color"):
		_show_color(text_edit)

func find_text_editor(node):
	for c in node.get_children():
		if c is TextEdit:
			if c.is_connected("cursor_changed", self, "_on_cursor_changed"):
				c.disconnect("cursor_changed", self, "_on_cursor_changed")
			c.connect("cursor_changed", self, "_on_cursor_changed", [c])
		if c.get_child_count() > 0:
			find_text_editor(c)

func _show_color(text_edit):
	if has_node("ColorPicker"):
		return
	
	var picker = load("res://addons/code_color_pick/interface.tscn").instance()
	text_edit.add_child(picker)
	picker.rect_position = text_edit.get_local_mouse_position()
	
	yield(picker.get_node("Button"), "button_up")
	text_edit.insert_text_at_cursor("(" + str(picker.color) + ")")
	picker.queue_free()
