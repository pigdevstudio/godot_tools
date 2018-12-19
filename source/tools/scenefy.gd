tool
extends EditorScript

const PATH = "res://characters/enemies/"
const SCENE_TYPE = AnimatedSprite

func _run():
	var interface = get_editor_interface()
	var filesys = interface.get_resource_filesystem()
	var dir = filesys.get_filesystem_path(PATH)
	
	for d in dir.get_subdir_count():
		var resource_name = dir.get_subdir(d).get_name()
		
		var n = SCENE_TYPE.new()
		n.name = resource_name
		
		var sprites = SpriteFrames.new()
		sprites.resource_name = resource_name
		
		sprites.rename_animation("default", "idle")
		
		var subdir = dir.get_subdir(d)
		
		for f in subdir.get_file_count():
			if f == subdir.get_file_count() - 1:
				sprites.add_animation("dead")
				sprites.add_frame("dead", load(subdir.get_file_path(f)), f)
			else:
				sprites.add_frame("idle", load(subdir.get_file_path(f)), f)
		
		sprites.set_animation_loop("idle", true)
		sprites.set_animation_speed("idle", 4)
		sprites.set_animation_loop("dead", false)
		sprites.set_animation_speed("dead", 1)
		
		var sprites_path = dir.get_path() + resource_name + ".tres"
		var scene_path = dir.get_path() + resource_name + ".tscn"
		
		ResourceSaver.save(sprites_path, sprites)
		
		n.frames = load(sprites_path)
		n.animation = "idle"
		
		var scene = PackedScene.new()
		scene.pack(n)
		
		ResourceSaver.save(scene_path, scene)
		
	filesys.scan()