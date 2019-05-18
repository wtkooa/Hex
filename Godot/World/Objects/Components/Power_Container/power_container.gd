extends Spatial

signal filled(type)
signal targeted(reference)
signal transmitted(data)
signal released()

export(NodePath) var UI_path = "Program/World/UI"
onready var UI = get_tree().get_root().get_node(self.UI_path)
export var _max_capacity = -1

var _current_amount = 0
var _filled = false
var _containter_name = "Power_Container"
var _Bound_UI

func _ready():
	self._Bound_UI = UI.get_node("Container_Gauge")
	self.connect("targeted", self._Bound_UI, "_on_Container_targeted")


func store(power):
	var receptacles = self.get_children()
	for receptacle in receptacles:
		
		if receptacle.is_filled():
			continue
		
		var element = receptacle.type()
		var amount = power.get_element(element)
		var theoretical_total_amount = self._current_amount + amount
		var theoretical_receptacle_amount = receptacle.current_amount() + amount
		
		var go_for_total = theoretical_total_amount < self._max_capacity or self._max_capacity == -1
		var go_for_receptacle = theoretical_receptacle_amount < receptacle.max_capacity() or receptacle.max_capacity() == -1
		
		if go_for_total and go_for_receptacle:
			
			self._current_amount = theoretical_total_amount
			receptacle.store(amount)
		
		else:
			
			var total_can_do_amount = theoretical_total_amount - self._max_capacity
			var receptacle_can_do_amount = theoretical_receptacle_amount - receptacle.max_capacity()
			
			if total_can_do_amount < 0 or receptacle_can_do_amount < 0:
				total_can_do_amount = 0
				receptacle_can_do_amount = 0
			
			var can_do_amount = [total_can_do_amount, receptacle_can_do_amount].min()
			self._current_amount += can_do_amount
			receptacle.store(can_do_amount)
			
			if receptacle_can_do_amount == can_do_amount:
				self.emit_signal("filled", element)
				receptacle.flag_as_filled()
			else:
				self.emit_signal("filled", "TOTAL")
				self._filled = true
	self.transmit()


func release():
	var packet = self.check()
	self.clear()
	return packet


func drain():
	self.transmit()


func check():
	var packet = Fundamental.new_packet()
	
	var receptacles = self.get_children()
	for receptacle in receptacles:
		var element = receptacle.type()
		var amount = receptacle.current_amount()
		packet.set_element(element, amount)
	return packet


func is_filled():
	return self._filled


func clear():
	self._current_amount = 0
	self._filled = false
	var receptacles = self.get_children()
	for receptacle in receptacles:
		receptacle.clear()
	self.transmit()


func bind(name):
	self._containter_name = name


func _on_Focus_Target_targeted(reference):
	self.emit_signal("targeted", self)


func data():
	var data = []
	data.append(self._containter_name)
	data.append([self._current_amount, self._max_capacity])
	data.append(self.get_children())
	return data


func transmit():
	self.emit_signal("transmitted", self.data())


func _on_Target_released():
	self.emit_signal("released")