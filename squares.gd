extends VBoxContainer

@onready var row1: HBoxContainer = $Row1
@onready var row2: HBoxContainer = $Row2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if row1.get_child_count()<5 and row2.get_child_count()>0:
		var squpgrade = row2.get_child(0)
		if not squpgrade:
			return
		
		squpgrade.reparent(row1)
	pass # Replace with function body.
