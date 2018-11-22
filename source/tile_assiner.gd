tool
extends EditorScript

func _run():
	var interface = get_editor_interface()
	var filesys = interface.get_resource_filesystem()
	var dir = filesys.get_filesystem_path(get_scene().tiles_folder)
	
	for f in dir.get_file_count():
		var path = dir.get_file_path(f)
		if not filesys.get_file_type(path) == "StreamTexture":
			continue
		get_scene().get_child(f).texture = (load(path))
