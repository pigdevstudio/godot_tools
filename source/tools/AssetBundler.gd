tool
extends EditorScript


func _run() -> void:
	var interface: = get_editor_interface()
	var current_path: = interface.get_current_path()
	var directory: = Directory.new()
	var selected_path: = get_editor_interface().get_selected_path()
	if directory.open(selected_path) == OK:
		if directory.make_dir("Bundle") == OK:
			bundle(current_path, selected_path + "/Bundle/")
			get_editor_interface().get_resource_filesystem().scan()
		else:
			print("An error occurred when trying to create the bundle folder.")
	else:
		print("An error occurred when trying to access the path.")


func bundle(current_path: String, target_path: String) -> void:
	var file: = File.new()
	if file.open(current_path, File.READ_WRITE) == OK:
		var file_string: = file.get_as_text()
		file.close()
		if file.open(target_path + current_path.get_file(), File.WRITE) == OK:
			var directory: = Directory.new()
			for dependency in ResourceLoader.get_dependencies(current_path):
				var new_dependency_path: String = target_path + dependency.get_file()
				if directory.copy(dependency, new_dependency_path) == OK:
					file_string.replace(dependency, new_dependency_path)
					if ResourceLoader.get_dependencies(dependency).size() > 0:
						bundle(dependency, target_path)
			file.store_string(file_string)
			file.close()
		else:
			print("An error occurred when trying to open the file.")
	else:
		print("An error occurred when trying to open the file.")
