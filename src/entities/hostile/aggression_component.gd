
extends SBComponent

var rage: float
var suspicion: float

func _update(delta: float) -> void: pass
func _physics_update(delta: float) -> void: pass

@export var radius: float = 4
@export var player: Player

@export var displacement: Vector2

func _setup(_sentient: SentientBase) -> void: 
	super(_sentient)
	_sentient.draw.connect(_draw)

func _draw() -> void:
	sentient.draw_circle(Vector2.ZERO, radius, Color.YELLOW, false, 3)
	
	sentient.draw_line(
		Vector2(radius * cos(atan2(player.position.y - sentient.position.y, player.position.x  - sentient.position.x)), radius * sin(atan2(player.position.y  - sentient.position.y, player.position.x  - sentient.position.x))),
		player.position - sentient.position,
		Color.BLUE if displacement.length() > 60 else Color.GREEN,
		2)

func _process(delta: float) -> void:
	displacement = (dist_from_to(Vector2(
		Vector2(radius * cos(atan2(player.position.y - sentient.position.y, player.position.x  - sentient.position.x)), radius * sin(atan2(player.position.y  - sentient.position.y, player.position.x  - sentient.position.x)))),
		player.position - sentient.position))
	
	print(displacement.length())
	sentient.queue_redraw()

func dist_from_to(_from: Vector2, _to: Vector2) -> Vector2:
	return _to - _from
