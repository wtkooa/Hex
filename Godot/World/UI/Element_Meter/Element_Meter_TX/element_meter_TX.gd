extends Spatial

signal transmitted(elemental_ratio)

export(NodePath) var UI_path = "Program/World/UI"

onready var UI = get_tree().get_root().get_node(self.UI_path)

var Bound_UI

func bind(name):
	self.Bound_UI = UI.get_node(name)
	self.connect("transmitted", Bound_UI, "_on_TX_transmitted")

func transmit(elemental_ratio):
	self.emit_signal("transmitted", elemental_ratio)