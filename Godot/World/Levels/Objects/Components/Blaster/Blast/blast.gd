extends Spatial

signal transmitted(power)

onready var Hit_Sound = self.get_node("Hit_Sound")
onready var Fire_Sound = self.get_node("Fire_Sound")

export(float) var speed = 5.0

var Blast_Target
var power
var active = false
var current_global_position


func aim_at(target):
	self.current_global_position = self.get_parent().to_global(self.translation)
	self.Blast_Target = target
	self.Blast_Target.connect("released", self, "_on_Blast_Target_released")
	self.connect("transmitted", self.Blast_Target, "_on_Blast_transmitted")


func charge_with(transfered_power):
	self.power = transfered_power


func activate():
	self.active = true
	self.visible = true
	self.Fire_Sound.play()


func deactivate():
	self.active = false
	self.visible = false


func _physics_process(delta):
	if active == false:
		return
	
	var target_global_position = Blast_Target.get_parent().to_global(Blast_Target.translation)
	var directional_vector = (target_global_position - self.current_global_position).normalized()
	self.current_global_position += directional_vector * speed * delta
	self.translation = self.get_parent().to_local(self.current_global_position)


func hit():
	self.deactivate()
	self.emit_signal("transmitted", self.power)
	self.Hit_Sound.play()
	yield(self.Hit_Sound, "finished")
	self.queue_free()


func _on_Blast_Target_released():
	self.queue_free()


func _on_Area_area_entered(area):
	if area.get_parent() == self.Blast_Target:
		self.hit()