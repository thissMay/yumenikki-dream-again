class_name Strategist extends Node

var strat_dict: Dictionary

@export var initial_strat	: Strategy
var current_strat	: Strategy
var previous_strat	: Strategy

func _setup() -> void:
	current_strat = initial_strat
func _change_strat(_new: Strategy): 
	previous_strat = current_strat
	current_strat = _new

func _process(_delta: float) -> void:
	if current_strat: current_strat._update(_delta, self)
func _physics_process(_delta: float) -> void:
	if current_strat: current_strat._physics_update(_delta, self)
	
