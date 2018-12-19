tool
extends AnimationPlayer

export (String) var undesired_path
export (bool) var fix_it = false setget set_fix_it

func set_fix_it(value):
	if !value:
		return
	undesired_path = undesired_path.to_lower()
	for a in get_animation_list():
		var anim = get_animation(a)
		for t in anim.get_track_count():
			var p = str(anim.track_get_path(t))
			p = p.to_lower()
			if p.begins_with(undesired_path):
				p.erase(0, undesired_path.length() + 1)
			print(p)
			anim.track_set_path(t, p)
		ResourceSaver.save(anim.get_path(), anim)