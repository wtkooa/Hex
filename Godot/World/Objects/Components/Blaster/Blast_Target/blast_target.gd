extends Spatial

signal received(power)
signal released

func _on_Target_released():
	self.emit_signal("released")


func _on_Blast_transmitted(power):
	self.emit_signal("received", power)
