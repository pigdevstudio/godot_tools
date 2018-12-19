tool
extends EditorScript

const PATH = "res://characters/enemies/"

func _run():
	var interface = get_editor_interface()
	var filesys = interface.get_resource_filesystem()
	var dir = filesys.get_filesystem_path(PATH)
	
	for f in dir.get_file_count():
		var path = dir.get_file_path(f)
		if not filesys.get_file_type(path) == "StreamTexture":
			continue
		
		var dir_name = dir.get_file(f)
		dir_name = dir_name.replace(".png", "")
		
		#Ad hoc solution to remove file "index" from directory's name
		if "0" in dir_name:
			dir_name.erase(dir_name.length() - 3, 3)
		
		var new_path = PATH + dir_name + "/"
		create_directory(new_path)
		move_file(path, new_path, dir.get_file(f))
	
	filesys.scan()

func create_directory(path):
	var dir = Directory.new()
	if dir.dir_exists(path):
		return
	dir.make_dir(path)

func move_file(path, new_path, file):
	var dir = Directory.new()
	dir.rename(path, new_path + file)
