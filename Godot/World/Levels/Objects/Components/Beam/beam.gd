extends Spatial

signal transmitted(power)

onready var Beam = self.get_node("Geometry")
onready var Sound_Effect = self.get_node("Sound_Effect")


func transmit(power, target):
	var bound_target = target.get_bound_object()
	if not bound_target.has_node("Beam_Target"):
		return
	
	var beam_target = bound_target.get_node("Beam_Target")
	self.connect("transmitted", beam_target, "_on_Beam_transmitted")
	self.emit_signal("transmitted", power)
	self.disconnect("transmitted", beam_target, "_on_Beam_transmitted")
	
	var global_beam_origin = self.to_global(self.translation)
	var global_beam_target = beam_target.to_global(beam_target.translation)
	var new_geometric_vectors = [global_beam_origin, global_beam_target]
	
	self.Beam.set_origin_and_target_vectors(new_geometric_vectors)
	
	self.Beam.visible = true
	
	if not self.Sound_Effect.playing:
		self.Sound_Effect.play()


func stop():
	self.Beam.visible = false
	self.Sound_Effect.stop()


