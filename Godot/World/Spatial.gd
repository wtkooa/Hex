extends Spatial

func _process(delta):
	self.rotate_y(0.5 * delta)