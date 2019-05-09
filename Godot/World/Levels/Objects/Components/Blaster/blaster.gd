extends Spatial

export(PackedScene) var Blast

func fire(power, target):
	var bound_target = target.get_bound_object()
	if not bound_target.has_node("Blast_Target"):
		return
	
	var Chambered_Blast = Blast.instance()
	self.add_child(Chambered_Blast)
	
	var blast_target = bound_target.get_node("Blast_Target")
	Chambered_Blast.aim_at(blast_target)
	Chambered_Blast.charge_with(power)
	Chambered_Blast.activate()