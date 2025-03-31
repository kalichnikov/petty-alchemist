extends Node

var is_dragging : bool = false
var phase1dict = {3: "red_solution", 5: "green_solution", 7: "blue_solution", 11: "brimstone", 15: "yellow_solution", 21: "magenta_solution", 35: "cyan_solution", 105: "white_solution", 163: "white_solution", 231: "white_solution", 315: "red_perditio", 385: "white_solution", 525: "green_perditio", 735: "blue_perditio", 1155: "white_solution", 1575: "blue_vitae", 2205: "green_vitae", 3465: "red_solution", 3675: "red_vitae", 5755: "green_solution", 8085: "blue_solution", 11025: "brimstone", 17325: "blue_brimstone", 24255: "green_brimstone", 40425: "red_brimstone", 1157625: "aqua_vitae"}

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

# crafting behavior for agitation or distillation
func phase1craft(val1: int, val2: int) -> String:
	# yandev voice: I wish there was an easier way to do this
	var newval = val1 * val2
	var created: String
	if phase1dict.has(newval): created = phase1dict[newval]
	elif newval % 81 == 0 or newval % 625 == 0 or newval % 2401 == 0: created = "boom"
	elif newval % 3375 == 0: created = "yellow_solution"
	elif newval % 9261 == 0: created = "magenta_solution"
	elif newval % 42875 == 0: created = "cyan_solution"
	elif newval % 27 == 0: created = "red_solution"
	elif newval % 125 == 0: created = "green_solution"
	elif newval % 343 == 0: created = "blue_solution"
	else: created = "boom"
	return created
