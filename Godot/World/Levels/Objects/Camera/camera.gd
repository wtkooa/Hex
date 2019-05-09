extends Camera

export(NodePath) var Target_Path
onready var Target_Node = self.get_node(Target_Path)

export(Vector3) var offset = Vector3(0.0, 10.0, 5.0)

func _process(delta):
	self.translation = self.Target_Node.translation + offset