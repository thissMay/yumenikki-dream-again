extends ConditionalSequence

@export var heading_condition: Entity.compass_headings
@export var speed_condition: float = 10
@export var area_region: AreaRegion
var pl: Player


func _ready() -> void:
	area_region.player_enter_handle.connect(func(_pl: Player): print("WHT"))
	super()
