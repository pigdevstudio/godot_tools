tool
extends EditorScript

#Path to the dependencies that must be checked, leave res:// for 
#global dependency fix
const PATH = "res://"

func _run():
	var interface = get_editor_interface()
	var filesys = interface.get_resource_filesystem()
	var dir = filesys.get_filesystem_path(PATH)
	
	var res = filesys.get_filesystem()
	
	#Take all the files in the PATH directory 
	for f in dir.get_file_count():
		var path = dir.get_file_path(f)
		var dependencies = ResourceLoader.get_dependencies(path)
		var file = File.new()
		
		# Check if the dependency is broken, if not it will skip it
		for d in dependencies:
			if file.file_exists(d):
				continue
			fix_dependency(d, res, path)
			
	#Take all the files in all PATH subdirectories
	for subdir in dir.get_subdir_count():
		subdir = dir.get_subdir(subdir)
		for f in subdir.get_file_count():
			var path = subdir.get_file_path(f)
			var dependencies = ResourceLoader.get_dependencies(path)
			var file = File.new()
			for d in dependencies:
				if file.file_exists(d):
					continue
				fix_dependency(d, res, path)

func fix_dependency(dependency, directory, resource_path):
	#Recursively call to enter in all the subdirectories until it reaches
	#the last subdir
	for subdir in directory.get_subdir_count():
		fix_dependency(dependency, directory.get_subdir(subdir), resource_path)
		
	#Fix all the files it finds during the recursive call
	for f in directory.get_file_count():
		if not directory.get_file(f) == dependency.get_file():
			continue
		var file = File.new()
		file.open(resource_path, file.READ_WRITE)
		var text = file.get_as_text()
		text = text.replace(dependency, directory.get_file_path(f))
		file.store_string(text)
		file.close()
