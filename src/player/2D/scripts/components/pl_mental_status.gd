extends SBComponent

const MAX_ADRENA := 100
const MAX_SANITY := 100
const MIN_SANE_THRESHOLD := 35
const MIN_INSANE_THRESHOLD := 30

var bpm: float = 0
const MAX_BPM = 180
const MIN_BPM = 60

var tinnitus: float: 	# --- [0 - 100] induces tinnitus. affects music and ambience volumes, and invokes rgb abberation.
	get: return roundf(tinnitus) 	
var tension: float: 	# --- [0 - 100] muffles music and ambience volumes.
	get: return roundf(tension)		
var fear: float: 		# --- [0 - 100] induces spiking BPM. affects music and ambience volumes and invokes distorted audio.
	get: return roundf(fear)			

func _setup(_sentient: SentientBase = null) -> void:
	super(_sentient)
	bpm = calculate_bpm()

func set_tinnitus(_tinnitus: float) -> void: tinnitus = _tinnitus
func set_tension(_tension: float) -> void: tension = _tension
func set_fear(_fear: float) -> void: fear = _fear
	
func calculate_bpm() -> float:
	var eqn := (
		60 * (fear / 100) +
		MIN_BPM)
	
	return (clampf(eqn, MIN_BPM, MAX_BPM))
