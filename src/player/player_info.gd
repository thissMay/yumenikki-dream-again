extends Resource

@export var name: String
@export_file("*.tscn") var character_path: String
@export_file("*.tscn") var inventory_path: String
@export() var inventory_data: PLInventoryData
