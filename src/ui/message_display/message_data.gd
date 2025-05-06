class_name MessageData
extends Resource

enum type {BASE, DIALOGUE, PROMPT}

@export_multiline var message: Array[String] = [""]
@export var message_type: type
