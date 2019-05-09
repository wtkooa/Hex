extends Spatial

signal targeted(reference)
signal detargeted(reference)

var bound_object = null
export(NodePath) var target_controller_path = "Program/World/Target_Controller"

onready var Target_Controller = get_tree().get_root().get_node(self.target_controller_path)


func _ready():
	self.connect("targeted", self.Target_Controller, "_on_targeted")
	self.connect("detargeted", self.Target_Controller, "_on_detargeted")


func _exit_tree():
	self._on_detargeted()


func bind(reference):
	self.bound_object = reference


func get_bound_object():
	return bound_object


func _on_targeted():
	self.emit_signal("targeted", self)


func _on_detargeted():
	self.emit_signal("detargeted", self)


func get_current_target():
	return Target_Controller.get_current_target()