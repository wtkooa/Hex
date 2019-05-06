extends Spatial

signal targeted(reference)
signal detargeted(reference)
signal detargeted_all

var bound_object = null

onready var Target_Controller = get_tree().get_root().get_node("Game").find_node("Target_Controller")

func _ready():
	self.connect("targeted", self.Target_Controller, "_on_targeted")
	self.connect("detargeted", self.Target_Controller, "_on_detargeted")
	Target_Controller.connect("detargeted_all", self, "_on_detargeted_all")


func _exit_tree():
	self._on_detargeted()
	Target_Controller.disconnect("detargeted_all", self, "_on_detargeted_all")


func bind(reference):
	self.bound_object = reference


func get_bound_object():
	return bound_object


func _on_targeted():
	self.emit_signal("targeted", self)


func _on_detargeted():
	self.emit_signal("detargeted", self)


func _on_detargeted_all(reference):
	self.emit_signal("detargeted_all")
	if self != reference:
		_on_detargeted()


func get_current_target():
	return Target_Controller.get_current_target()