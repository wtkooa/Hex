extends Spatial

export(Fundamental.ELEMENTS) var _type
export var _max_capacity = -1

var _current_amount = 0
var _filled = false


func type():
	return self._type


func current_amount():
	return _current_amount


func max_capacity():
	return self._max_capacity


func store(amount):
	self._current_amount += amount


func flag_as_filled():
	self._filled = true


func is_filled():
	return self._filled


func clear():
	self._current_amount = 0
	self._filled = false