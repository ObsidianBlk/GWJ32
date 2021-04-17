extends Spatial
tool


export (float, 0.0, 100.0) var radius = 10.0 setget _set_radius

var material = preload("res://objects/tools/wanderspace/WanderSpace.material")
var RNG = RandomNumberGenerator.new()

onready var mesh = $Mesh


func _set_radius(r : float):
	radius = r
	if mesh and Engine.editor_hint:
		mesh.mesh.radius = radius

func _ready():
	RNG.randomize()
	
	if Engine.editor_hint:
		var sm = SphereMesh.new()
		sm.height = 0.25
		sm.is_hemisphere = true
		sm.material = material
		mesh.mesh = sm
		_set_radius(radius)
	else:
		mesh.visible = false

func get_random_point():
	var pos = global_transform.origin
	var rad = RNG.randf_range(radius * 0.25, radius)
	var deg = 359.9 * RNG.randf()
	var dir = global_transform.basis.z.rotated(Vector3.UP, deg2rad(deg))
	return pos + (Vector3(dir.x * rad, dir.y, dir.z*rad))
