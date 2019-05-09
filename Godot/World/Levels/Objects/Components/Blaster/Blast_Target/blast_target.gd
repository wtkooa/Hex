extends Spatial

signal received(power)
signal released

func _on_Blast_Target_tree_exiting():
	self.emit_signal("released")


func _on_Blast_transmitted(power):
	self.emit_signal("received", power)
