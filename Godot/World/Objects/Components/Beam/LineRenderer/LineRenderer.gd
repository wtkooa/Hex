extends ImmediateGeometry

onready var beam_material = self.material_override

export var points = [Vector3(0,0,0),Vector3(0,5,0)]
export var startThickness = 0.1
export var endThickness = 0.1

var camera
var cameraOrigin

func _ready():
	pass

func _process(delta):
	if points.size() < 2:
		return
	
	camera = get_viewport().get_camera()
	if camera == null:
		return
	cameraOrigin = to_local(camera.get_global_transform().origin)
	
	var thickness = startThickness
	var nextThickness = endThickness
	
	clear()
	begin(Mesh.PRIMITIVE_TRIANGLES)
	

	var A = points[0]
	var B = points[1]
	
	A = to_local(A)
	B = to_local(B)
	
	var AB = B - A;
	var orthogonalABStart = (cameraOrigin - ((A + B) / 2)).cross(AB).normalized() * thickness;
	var orthogonalABEnd = (cameraOrigin - ((A + B) / 2)).cross(AB).normalized() * nextThickness;

	var AtoABStart = A + orthogonalABStart
	var AfromABStart = A - orthogonalABStart
	var BtoABEnd = B + orthogonalABEnd
	var BfromABEnd = B - orthogonalABEnd
		
	var ABLen = AB.length()
	var ABFloor = floor(ABLen)
	var ABFrac = ABLen - ABFloor

	set_uv(Vector2(ABFloor, 0))
	add_vertex(AtoABStart)
	set_uv(Vector2(-ABFrac, 0))
	add_vertex(BtoABEnd)
	set_uv(Vector2(ABFloor, 1))
	add_vertex(AfromABStart)
	set_uv(Vector2(-ABFrac, 0))
	add_vertex(BtoABEnd)
	set_uv(Vector2(-ABFrac, 1))
	add_vertex(BfromABEnd)
	set_uv(Vector2(ABFloor, 1))
	add_vertex(AfromABStart)
	
	end()

func set_origin_and_target_vectors(new_points):
	self.points = new_points


func colorize(color):
	self.beam_material.albedo_color.r = color.r
	self.beam_material.albedo_color.g = color.g
	self.beam_material.albedo_color.b = color.b
	self.beam_material.emission = color


