tool
extends EditorScript

func _run() -> void:
	bundle()


func bundle():
	var interface = get_editor_interface()
	var path = interface.get_current_path()
	var file = File.new()
	file.open(path, File.READ_WRITE)
	var directory = Directory.new()
	var current_dir = get_editor_interface().get_selected_path()
	directory.open(current_dir)
	directory.make_dir("Bundle")
	var new_file = File.new()
	new_file.open(current_dir + "/Bundle/" + path.get_file(), File.WRITE_READ)
	var string = file.get_as_text()
	for dependency in ResourceLoader.get_dependencies(path):
		var new_dependency_path = current_dir + "/Bundle/" + dependency.get_file()
		directory.copy(dependency, new_dependency_path)
		string.replace(dependency, new_dependency_path)
	new_file.store_string(string)
	new_file.close()
	file.close()
	get_editor_interface().get_resource_filesystem().scan()
