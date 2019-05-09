extends Spatial

signal received(power)

func _on_Beam_transmitted(power):
	self.emit_signal("received", power)