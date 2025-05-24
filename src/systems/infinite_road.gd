@tool
extends SeamlessDetector

var world_loop_listener: EventListener
@export var hidden_thing: Node2D
@export_file("*.tscn") var scene_path: String


func _ready() -> void:
	super()

	var world_loop_listener := EventListener.new(["WORLD_LOOP"], false, self)	
	world_loop_listener.do_on_notify("WORLD_LOOP", func(): 
		if loop_count >= 5: hidden_thing.visible = true)

			

func _handle_player_warp_left(_pl: Area2D) -> void: 
	super(_pl)
	if loop_count >= 5: GameManager.change_scene_to(load(scene_path))
