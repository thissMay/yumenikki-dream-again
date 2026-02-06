extends Control

var player: Player

@export var positive_colour: Color = Color.GREEN
@export var negative_colour: Color = Color.RED

@export_group("Mobility Stats")
@export var walk_speed: Control
@export var sprint_speed: Control
@export var sneak_speed: Control

@export_group("Mobility Flags")
@export var can_sprint: Control

@export_group("Noise Stats")
@export var walk_noise: Control
@export var sprint_noise: Control
@export var sneak_noise: Control

@onready var default_player_stats 		:= Player.Instance.DEFAULT_EQUIPMENT
@onready var stats_neutral_indicator 	:= load("res://src/player/inventory/stats_neutral.png")
@onready var stats_positive_indicator 	:= load("res://src/player/inventory/stats_positive.png")
@onready var stats_negative_indicator 	:= load("res://src/player/inventory/stats_negative.png")

var player_updated: 		EventListener

func _ready() -> void:
	player_updated 			= EventListener.new(self, "PLAYER_UPDATED")
	player_updated.do_on_notify(
		func():
			player = EventManager.get_event_param("PLAYER_UPDATED")[0]
			update_stats_display, 
		"PLAYER_UPDATED")

func update_stats_display() -> void:
	handle_stats_display_value(walk_speed, "WALK SPEED: \t%.2f m/s" % 		(player.values.walk_multi * SentientBase.BASE_SPEED / 16))
	handle_stats_display_value(sprint_speed, "SPRINT SPEED: \t%.2f m/s" % 	(player.values.sprint_multi * SentientBase.BASE_SPEED / 16))
	handle_stats_display_value(sneak_speed, "SNEAK SPEED: \t%.2f m/s" % 	(player.values.sneak_multi * SentientBase.BASE_SPEED / 16))
	
	handle_stats_display_value(can_sprint, "CAN SPRINT?: \t%s" 					% player.values.can_sprint)
	
	handle_stats_display_value(walk_noise, "WALK NOISE: \t%.2f db" 		% (player.values.walk_noise_multi / 1.8 * 55))
	handle_stats_display_value(sprint_noise, "SPRINT NOISE: \t%.2f db" 	% (player.values.sprint_noise_multi / 1.8 * 55))
	handle_stats_display_value(sneak_noise, "SNEAK NOISE: \t%.2f db" 	% (player.values.sneak_noise_multi / 1.8 * 55))
	
	handle_stats_display_improvement(walk_speed, 	Player.WALK_MULTI * player.values.walk_multi, Player.WALK_MULTI)
	handle_stats_display_improvement(sprint_speed, 	Player.SPRINT_MULTI * player.values.sprint_multi, Player.SPRINT_MULTI)
	handle_stats_display_improvement(sneak_speed, 	Player.SNEAK_MULTI * player.values.sneak_multi, Player.SNEAK_MULTI)
			
	handle_stats_display_improvement(can_sprint, 	player.values.can_sprint, Player.CAN_SPRINT)

	handle_stats_display_improvement(walk_noise, 	-Player.WALK_NOISE_MULTI * -player.values.walk_noise_multi, -Player.WALK_NOISE_MULTI)
	handle_stats_display_improvement(sprint_noise, -Player.SPRINT_NOISE_MULTI * -player.values.sprint_noise_multi, -Player.SPRINT_NOISE_MULTI)
	handle_stats_display_improvement(sneak_noise, -Player.SNEAK_NOISE_MULTI * -player.values.sneak_noise_multi, -Player.SNEAK_NOISE_MULTI)
				

func handle_stats_display_value(_stat: Control, _text: String) -> void:
	if _stat.has_node("text"): _stat.get_node("text").text = str(_text)
	else: return
func handle_stats_display_improvement(_stat: Control, _value: float, _to_compare: float) -> void:
	if _stat.has_node("icon") and _stat.has_node("text"):
		if _value == _to_compare: 
			_stat.get_node("icon").texture = stats_neutral_indicator
			_stat.get_node("text").self_modulate = Color.WHITE
		elif _value > _to_compare: 
			_stat.get_node("icon").texture = stats_positive_indicator
			_stat.get_node("text").self_modulate = positive_colour
		elif _value < _to_compare: 
			_stat.get_node("icon").texture = stats_negative_indicator
			_stat.get_node("text").self_modulate = negative_colour
