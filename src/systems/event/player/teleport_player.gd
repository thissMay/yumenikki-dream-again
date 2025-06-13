extends Event


@export var dir: Vector2 = Vector2(0, 1)
@export var target: Node2D
@export var as_sibling: bool = true

func _ready() -> void:
	if target == null: return
	target.draw.connect(_draw)
	
	if !Engine.is_editor_hint(): 
		set_process(false)

func _draw() -> void:
	if Engine.is_editor_hint():
		var mado_sprite = preload("res://src/player/madotsuki/display/default/_RESET.png")
		var arrow_sprite = preload("res://src/images/arrow_direction.png")
		
		target.draw_texture(mado_sprite, target.global_position - mado_sprite.get_size() / 2, Color(1, 1, 1, .5))
		if target != null:
			target.draw_line(Vector2.ZERO, target.global_position - self.global_position, Color.RED)
			
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): 
		target.queue_redraw()
		if target == self: target = null

func _execute() -> void:
	if target != null:
		PLInstance.teleport_player(target.global_position, dir)
		if as_sibling: PLInstance.get_pl().reparent(target.get_parent().get_parent())
		else: PLInstance.get_pl().reparent(target.get_parent())
		
