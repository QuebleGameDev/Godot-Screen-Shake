extends Camera2D

@export var decay : float = 0.8 # Time it takes to reach 0% of trauma
@export var max_offset : Vector2 = Vector2(100, 75) # Max hor/ver shake in pixels
@export var max_roll : float = 0.1 # Maximum rotation in radians (use sparingly)
@export var follow_node : Node2D # Node to follow (assign this to your player)

var trauma : float = 0.0 # Current shake strength
var trauma_power : int = 2 # Trauma exponent. Increase for more extreme shaking

func _input(event: InputEvent) -> void:
	#? Add trauma when space is pressed
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		add_trauma(0.5)

func _ready() -> void:
	#? Randomize the game seed
	randomize()

func _process(delta : float) -> void:
	if follow_node: # If the follow node exists
		global_position = follow_node.global_position # Set the camera's position to the follow node's position
	if trauma: # If the camera is currently shaking
		trauma = max(trauma - decay * delta, 0) # Decay the shake strength
		shake() # Shake the camera

## The function to use for adding trauma (screen shake)
func add_trauma(amount : float) -> void:
	trauma = min(trauma + amount, 1.0) # Add the amount of trauma (capped at 1.0)

## This function is used to actually apply the shake to the camera
func shake() -> void:
	#? Set the camera's rotation and offset based on the shake strength
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
