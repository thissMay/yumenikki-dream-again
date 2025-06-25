@tool
extends SeamlessDetector

var world_loop_listener: EventListener
@export var hidden_thing: Node2D
@export_file("*.tscn") var scene_path: String


func _ready() -> void:
	super()
	var world_loop_listener := EventListener.new(["WORLD_LOOP"], false, self)	

	pl_warped_left.connect(func():
		if loop_record[bound_side.LEFT] >= 5: GameManager.change_scene_to(load(scene_path)) )
	world_loop_listener.do_on_notify("WORLD_LOOP", func(): 
		if loop_record[bound_side.LEFT] > 5: hidden_thing.visible = true)
