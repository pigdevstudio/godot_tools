tool
extends EditorPlugin

func _ready():
	get_editor_interface().get_selection().connect("selection_changed", self,
			"_on_selection_changed")
	set_process_input(false)
	
func _on_selection_changed():
	if get_editor_interface().get_selection().get_selected_nodes().size() > 1:
		set_process_input(true)
	else:
		set_process_input(false)

func _input(event):
	if Input.is_key_pressed(KEY_F12):
		var r = load("res://addons/batch_rename/interface.tscn").instance()
		r.get_node("LineEdit").connect("text_entered", self,
				"_on_text_entered", [r])
		get_editor_interface().get_base_control().add_child(r)
		
func _on_text_entered(new_text, interface):
	var nodes = get_editor_interface().get_selection().get_selected_nodes()
	nodes.sort_custom(self, "sort_by_index")
	
	for n in nodes:
		n.name = new_text
	
	interface.queue_free()
	
func sort_by_index(a, b):
	return a.get_index() < b.get_index()
