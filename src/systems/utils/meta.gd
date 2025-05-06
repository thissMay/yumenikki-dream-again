extends RichTextLabel

func _ready() -> void:
	meta_clicked.connect(func(_meta: Variant): 	OS.shell_open(_meta))
