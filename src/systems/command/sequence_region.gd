class_name SequenceRegion
extends Area2D

var region_priority: int = 0
var rect: CollisionShape2D

@export var enter_sequence: Sequence
@export var exit_sequence: Sequence

func _ready() -> void:
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
		
	rect = $rect
		
	self.body_entered.connect(
		func(body: Node2D): 
			if body is Player: if enter_sequence: enter_sequence.execute())
	self.body_exited.connect(
		func(body: Node2D): 
			if body is Player: if exit_sequence: exit_sequence.execute())
