extends Spatial


func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()