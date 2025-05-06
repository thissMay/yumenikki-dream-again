extends SceneNode

# ---- read only labels.
var readonly_basepeed: Label

var readonly_walkmulti: Label
var readonly_sprintmulti: Label
var readonly_sneakmulti: Label

var readonly_sanity: Label
var readonly_adrenaline: Label

var readonly_coords: Label
var readonly_velocity: Label

# ---- setter ui

var override_walkmulti: SpinBox
var override_sprintmulti: SpinBox
var override_sneakmulti: SpinBox

@export var time_scale: HSlider

func _ready() -> void:
	readonly_basepeed = $player_mobil_readonly/mobility_readonly/_/base_speed
	
	readonly_walkmulti = $player_mobil_readonly/mobility_readonly/_/walk_multi
	readonly_sprintmulti = $player_mobil_readonly/mobility_readonly/_/sprint_multi
	readonly_sneakmulti = $player_mobil_readonly/mobility_readonly/_/sneak_multi
	
	readonly_sanity = $player_stats_readonly/stats_readonly/_/sanity
	
	readonly_coords = $player_stats_readonly/coordinates_readonly/_/coords
	readonly_velocity = $player_stats_readonly/coordinates_readonly/_/velocity
	
	#----
	override_walkmulti = $player_mobil_readonly/mobility_setter_ui/_/walk_multi/spin_box
	override_sprintmulti = $player_mobil_readonly/mobility_setter_ui/_/sprint_multi/spin_box
	override_sneakmulti = $player_mobil_readonly/mobility_setter_ui/_/sneak_multi/spin_box
	
	if PLInstance.get_pl() != null:
		override_walkmulti.value = PLInstance.get_pl().walk_multiplier
		override_sprintmulti.value = PLInstance.get_pl().sprint_multiplier
		override_sneakmulti.value = PLInstance.get_pl().sneak_multiplier
	
func _process(delta: float) -> void:
	if PLInstance.get_pl() != null:
		readonly_basepeed.text = str("BASE Speed:  ", PLInstance.get_pl().BASE_SPEED)

		readonly_walkmulti.text = str("WALK Multi:  ", PLInstance.get_pl().walk_multiplier)
		readonly_sprintmulti.text = str("SPRINT Multi:  ", PLInstance.get_pl().sprint_multiplier)
		readonly_sneakmulti.text = str("SNEAK Multi:  ", PLInstance.get_pl().sneak_multiplier)
		
		readonly_sanity.text = str("SANITY:  ", PLInstance.sanity)
		
		readonly_coords.text = str("COORDS:  ", PLInstance.get_pl().global_position)
		readonly_velocity.text = str("VELOCITY:  ", PLInstance.get_pl().velocity)
	
		time_scale.value = Game.get_timescale()
