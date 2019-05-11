extends Node

enum ELEMENTS {OORA, UNDA, KYDA, CYRA, FLORA, ERDA}

var Packed_Packet = load("res://World/Fundamental/Packet/Packet.tscn")
func new_packet():
	return Packed_Packet.instance()