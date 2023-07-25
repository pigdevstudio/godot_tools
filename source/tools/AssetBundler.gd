@tool
extends EditorScript


func _run():
	var interface = get_editor_interface()
	var selected_paths = get_editor_interface().get_selected_paths()
	for path in selected_paths:
		var directory = DirAccess.open(path.get_base_dir())
		var file_name = path.get_file().replace("." + path.get_extension(), "")
		directory.make_dir(file_name)
		var target_dir = path.get_base_dir() + "/%s/" % file_name
		directory.copy(path, target_dir + path.get_file())
		bundle(path, target_dir)
	get_editor_interface().get_resource_filesystem().scan()


func bundle(selected_file, target_path):
	for dependency in ResourceLoader.get_dependencies(selected_file):
		var erasing_start = dependency.find("res://")
		var erased = dependency.erase(erasing_start, dependency.length())
		var dependency_path = dependency.replace(erased, "")
		var new_dependency_path = target_path + dependency_path.get_file()
		var directory = DirAccess.open(target_path.get_base_dir())
		directory.copy(dependency_path, new_dependency_path)
		for sub_dependency in ResourceLoader.get_dependencies(dependency_path):
			bundle(dependency_path, target_path)
	var directory = DirAccess.open(target_path)
	directory.copy(selected_file, target_path)
