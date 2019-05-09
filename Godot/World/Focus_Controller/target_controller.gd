extends Spatial

signal detargeted(reference)

var current_target = null

func _on_targeted(reference):
	self.emit_signal("detargeted", self.current_target)
	self.current_target = reference

func _on_detargeted(reference):
	if current_target == reference:
		current_target = null

func get_current_target():
	return self.current_target