class_name OnScreenNotifier
extends VisibleOnScreenNotifier2D

@export var process_mode_enabling: Node.ProcessMode = Node.PROCESS_MODE_INHERIT

var node: Node
var visible_prior: bool = true

func _ready() -> void:	
	node = get_parent() 
	if node is CanvasItem: visible_prior = node.visible 

	screen_entered.connect(_on_screen_enter)
	screen_exited.connect(_on_screen_exit)
	
	await RenderingServer.frame_post_draw
	
	if is_on_screen()	: _on_screen_enter()
	else				: _on_screen_exit()

func _on_screen_enter() -> void: 
	node.process_mode = process_mode_enabling
	if ((node is CanvasItem) and visible_prior): node.visible = true
func _on_screen_exit() -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	if (node is CanvasItem): 
		visible_prior = node.visible
		node.visible = false
