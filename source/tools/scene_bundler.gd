tool
extends EditorScript


func _run() -> void:
	var interface = get_editor_interface()
	var path = interface.get_current_path()
	var directory = Directory.new()
	var current_dir = get_editor_interface().get_selected_path()
	directory.open(current_dir)
	directory.make_dir("Bundle")
	bundle(path, current_dir + "/Bundle/")
	get_editor_interface().get_resource_filesystem().scan()


func bundle(path, target_path):
	var file = File.new()
	file.open(path, File.READ_WRITE)
	var string = file.get_as_text()
	file.close()
	file.open(target_path + path.get_file(), File.WRITE)

	var directory = Directory.new()
	for dependency in ResourceLoader.get_dependencies(path):
		var new_dependency_path = target_path + dependency.get_file()
		directory.copy(dependency, new_dependency_path)
		string.replace(dependency, new_dependency_path)
		if ResourceLoader.get_dependencies(dependency).size() > 0:
			bundle(dependency, target_path)
	file.store_string(string)
	file.close()
