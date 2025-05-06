class_name SBHealth
extends SBComponent

const DEF_MAX_HEALTH: float = 100
const DEF_BLOOD_COLOR: Color = Color(Color.DARK_RED)

var max_health: float = DEF_MAX_HEALTH 
var health: float = DEF_MAX_HEALTH

@export var blood_particles: CPUParticles2D
@export var blood_color: Color = DEF_BLOOD_COLOR
var blood_particle_texture: Texture = preload("res://src/levels/dream/sane/melancholy_meadows/sprites/dust.png")

signal took_damage(_dmg: float)

func _take_damage() -> void: pass
