extends Spatial

signal transmitted(power)

onready var Beam = self.get_node("Geometry")
onready var End_of_Beam_Particles = self.get_node("End_of_Beam_Particles")
onready var Transferring_Sound = self.get_node("Transferring")
onready var Spinup_Sound = self.get_node("Spinup")
onready var Cooldown_Sound = self.get_node("Cooldown")

export var _max_beam_distance = 10.0
var _current_beam_target = null


func aim_at(target):
	if self.Cooldown_Sound.playing:
		return
	
	var bound_object = target.get_bound_object()
	if not bound_object.get_node("Beam_Target"):
		return
		
	self._current_beam_target = bound_object.get_node("Beam_Target")
	
	if self.beam_target_distance() > self._max_beam_distance:
		self._current_beam_target = null
		self.stop()
		return
	
	self._current_beam_target.connect("released", self, "_on_Beam_Target_released")

	if not self.Spinup_Sound.playing:
		self.Spinup_Sound.play()


func transmit(power):
	if self.Spinup_Sound.playing:
		return
	
	if self._current_beam_target == null:
		return
	
	var global_beam_origin = self.to_global(self.translation)
	var global_beam_target = self._current_beam_target.to_global(self._current_beam_target.translation)
	var beam_distance = global_beam_origin.distance_to(global_beam_target)
	var new_geometric_vectors = [global_beam_origin, global_beam_target]
	
	if beam_distance > self._max_beam_distance:
		self.stop()
		return
	
	self.Beam.set_origin_and_target_vectors(new_geometric_vectors)
	self.End_of_Beam_Particles.translation = self.to_local(global_beam_target)
	
	var normalized_power = Fundamental.new_packet()
	normalized_power.set_power(power.get_power())
	normalized_power.normalize()
	var color = self.calc_elemental_color(normalized_power)
	self.Beam.colorize(color)
	self.End_of_Beam_Particles.draw_pass_1.material.albedo_color = color
	
	if not self.Transferring_Sound.playing:
		self.Transferring_Sound.play()
	
	self.connect("transmitted", self._current_beam_target, "_on_Beam_transmitted")
	self.emit_signal("transmitted", power)
	self.disconnect("transmitted", self._current_beam_target, "_on_Beam_transmitted")
	
	if not self.Beam.visible:
		self.Beam.visible = true
	
	if not self.End_of_Beam_Particles.visible:
		self.End_of_Beam_Particles.visible = true


func stop():
	if not self._current_beam_target == null:
		self._current_beam_target.disconnect("released", self, "_on_Beam_Target_released")
		if not self.Cooldown_Sound.playing:
			if self.Spinup_Sound.playing:
				yield(self.Spinup_Sound, "finished")
		self.Cooldown_Sound.play()
	
	self._current_beam_target = null
	self.Beam.visible = false
	self.End_of_Beam_Particles.visible = false
	self.Transferring_Sound.stop()
	


func _on_Beam_Target_released():
	self.stop()


func set_max_beam_distance(distance):
	self._max_beam_distance = distance


func beam_target_distance():
	var global_beam_origin = self.to_global(self.translation)
	var global_beam_target = self._current_beam_target.to_global(self._current_beam_target.translation)
	var beam_distance = global_beam_origin.distance_to(global_beam_target)
	return beam_distance


func calc_elemental_color(elemental_ratio):
	var color = Vector3(0.5, 0.5, 0.5)
	
	var oora = elemental_ratio.get_element(Fundamental.ELEMENTS.OORA)
	oora *= 0.5
	color += Vector3(oora, oora, oora)
	
	var unda = elemental_ratio.get_element(Fundamental.ELEMENTS.UNDA)
	unda *= 0.5
	color -= Vector3(unda, unda, unda)
	
	var kyda = elemental_ratio.get_element(Fundamental.ELEMENTS.KYDA)
	kyda *= 0.5
	color += Vector3(kyda, 0.0, 0.0)
	
	var cyra = elemental_ratio.get_element(Fundamental.ELEMENTS.CYRA)
	cyra *= 0.5
	color += Vector3(0.0, 0.0, cyra)
	
	var flora = elemental_ratio.get_element(Fundamental.ELEMENTS.FLORA)
	flora *= 0.5
	color += Vector3(0.0, flora, 0.0)
	
	var erda = elemental_ratio.get_element(Fundamental.ELEMENTS.ERDA)
	erda *= 0.5
	color += Vector3(erda, erda, 0.0)
	
	for value in color:
		if value > 1.0:
			value = 1.0
		if value < 0:
			value = 0
	
	return Color(color.x, color.y, color.z, 1.0)

