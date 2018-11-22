tool
extends Node

export (String) var new_name = ""
export (bool) var apply = false setget set_apply

func set_apply(value):
	if not value:
		return
	for c in get_children():
		c.name = new_name + str(c.get_index() + 1)