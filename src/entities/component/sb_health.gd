class_name SBHealth
extends SBComponent

const DEF_MAX_HEALTH: float = 100
const DEF_BLOOD_COLOR: Color = Color(Color.DARK_RED)

var max_health: float = DEF_MAX_HEALTH 
var health: float = DEF_MAX_HEALTH
var death: SBComponent

@export var blood_particles: CPUParticles2D
@export var blood_color: Color = DEF_BLOOD_COLOR
var blood_particle_texture: Texture = preload("res://src/levels/nexus_snow/snow.png")

signal took_damage(_dmg: float)

func _setup(_sentient: SentientBase) -> void:
	super(_sentient)
	blood_particles.one_shot = true
	blood_particles.restart()
	took_damage.connect(blood_particles.restart)
func _take_damage() -> void: pass
