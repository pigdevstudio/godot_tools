tool
extends EditorPlugin

var current_text_edit = null
signal dropped

func _ready():
	get_editor_interface().get_script_editor().connect("editor_script_changed",
			self, "_on_editor_script_changed")
			
	find_text_editor(get_editor_interface().get_script_editor())
	
	connect("main_screen_changed", self, "_on_main_screen_changed")
	
	set_process_input(false)
	set_process(false)
	set_physics_process(false)
	
func _on_main_screen_changed(new_screen):
	set_process_input(new_screen == "Script")

func find_text_editor(node):
	for c in node.get_children():
		if c is TextEdit:
			if c.is_connected("mouse_entered", self, "_on_mouse_entered"):
				c.disconnect("mouse_entered", self, "_on_mouse_entered")
			c.connect("mouse_entered", self, "_on_mouse_entered", [c])
		if c.get_child_count() > 0:
			find_text_editor(c)

func _on_editor_script_changed(new_script):
	find_text_editor(get_editor_interface().get_script_editor())
	
func _on_mouse_entered(text_edit):
	current_text_edit = text_edit
	
	var data = get_viewport().gui_get_drag_data()
	if not data:
		return
	
	var i = load("res://addons/drag_n_drop/interface.tscn").instance()
	text_edit.add_child(i)
	
	yield(self, "dropped")
	i.queue_free()

func _input(event):
	if current_text_edit == null:
		return
	if not event is InputEventMouseButton:
		return
	if event.is_pressed():
		return
	
	var data = get_viewport().gui_get_drag_data()
	if not data:
		return
	if data.type == "obj_property":
		_drop_property(data)
	elif data.type == "nodes":
		_drop_node(data)

func _drop_property(data):
	var text = ""
	
	if data.object == get_editor_interface().get_edited_scene_root():
		text = data.property
	else:
		var path = get_editor_interface().get_edited_scene_root().get_path_to(data.object)
		text = "$%s.%s"%[path, data.property]
	
	if Input.is_key_pressed(KEY_SHIFT):
		text = text + " = "

	current_text_edit.insert_text_at_cursor(text)
	emit_signal("dropped")

func _drop_node(data):
	var text = ""
	var nodes = get_editor_interface().get_selection().get_selected_nodes()
	for n in nodes:
		var path = get_editor_interface().get_edited_scene_root().get_path_to(n)
		if Input.is_key_pressed(KEY_SHIFT):
			text = 'onready var %s = get_node("%s")\n'%[n.name.to_lower(), path]
			current_text_edit.insert_text_at_cursor(text)
		else:
			text = 'get_node("%s")'%[path]
			current_text_edit.insert_text_at_cursor(text)
			break
	emit_signal("dropped")
