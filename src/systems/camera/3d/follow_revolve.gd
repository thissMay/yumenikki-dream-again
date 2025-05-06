extends Camera3D

@export var distance: float = 400 # the camera's "distance" from the poi, this is not real distance, just a visual illusion
@export var r: float = 1 # radius of revolution
@export var poi: Node3D # what 3D object to look at, must be Node3D
@export var speed: float = 5

var cam_initial_displacement: float


func _ready() -> void:
	await owner.ready
	
	# cameraholder is the cam defined in "To You" project (thissmay)
	# just replace it with your camera reference.
	self.global_position.x = r * cos((1 / distance * PI) * (-CameraHolder.cam.global_position.x + cam_initial_displacement)) + poi.position.x
	self.global_position.z = r * sin((1 / distance * PI) * (-CameraHolder.cam.global_position.x + cam_initial_displacement)) + poi.position.z

func _process(delta: float) -> void:
	if poi: # if node3D exists:
		look_at(poi.global_position) # adjusts camera rotation to the object's GLOBAL position (note: use global).

		if CameraHolder.cam: 	
			
			# equation stuff, don't mind it.
			# like mentioned, replace cameraholder with whatever x-axis you want the camera 3D to respond to.
			
			self.global_position.x = lerp(
				self.global_position.x,
				r * cos((1 / distance * PI) * (-CameraHolder.cam.global_position.x + cam_initial_displacement)) + poi.position.x,
				delta * speed)
			self.global_position.z = lerp(
				self.global_position.z,
				r * sin((1 / distance * PI) * (-CameraHolder.cam.global_position.x + cam_initial_displacement)) + poi.position.z,
				delta * speed)
