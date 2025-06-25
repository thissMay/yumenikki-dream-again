class_name PLInteractionManager
extends SBComponent

@export var field: Area2D
@export var ray_direction: Vector2
@export var ray_distance: float = 35

signal interactable_found
var found: bool = false

const COOL_DOWN = 1.5
var interaction_cooldown: float = COOL_DOWN
var cooldown: bool = false
var curr_interactable: Interactable
var prompt_icon: Sprite2D

var closest_interactable_threshold: float = 100
var interactables: Array[Interactable] 

func _ready() -> void:
	prompt_icon = $prompt
	field = $field
	
	field.collision_layer = 2
	field.collision_mask = 2

	interactables.resize(5)
	field.area_entered.connect(interactable_entered)
	field.area_exited.connect(interactable_exited)
	
	interactable_found.connect(func():
		
		)
	
func _update(delta: float) -> void:
	handle_field()
	field.rotation = sentient.get_dir().angle()
	
	if cooldown: 
		interaction_cooldown -= delta
		if interaction_cooldown <= 0: 
			cooldown = false 
			interaction_cooldown = COOL_DOWN
			
	if (curr_interactable != null and 
		!found and !curr_interactable.secret)	: found = true
	else										: found = false

func _input_pass(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"): handle_interaction()

	
func handle_field() -> void: 

	for i in range(interactables.size()):
		if interactables[i] != null:
			if interactables[i].global_position.distance_to(self.global_position) < closest_interactable_threshold: 
				closest_interactable_threshold = interactables[i].global_position.distance_to(self.global_position)
				curr_interactable = interactables[i] 
			else:
				closest_interactable_threshold = 100
				break
		else: 
			if interactables[i - 1]: curr_interactable = interactables[i - 1]
			else: curr_interactable = null
			break
func handle_interaction() -> void: 
	if curr_interactable and !cooldown: 
		if (
			
			sentient.get_dir().x >= curr_interactable.dir_min.x and 
			sentient.get_dir().x <= curr_interactable.dir_max.x and
			
			-sentient.get_dir().y >= curr_interactable.dir_min.y and 
			-sentient.get_dir().y <= curr_interactable.dir_max.y
			
			) or curr_interactable.omni_dir:
				
				curr_interactable.interact()
				cooldown = true	
# ---- signals -----
func interactable_entered(_inact: Area2D) -> void: 
	if _inact is Interactable:
		for i in range(interactables.size()):
			if interactables[i] == null: interactables[i] = _inact
			break
func interactable_exited(_inact: Area2D) -> void: 
	if _inact is Interactable:
		interactables[interactables.find(_inact)] = null

# ----

func show_prompt(_show: bool) -> void: 
	match _show:
		true: pass
		false: pass
