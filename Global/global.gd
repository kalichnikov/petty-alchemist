extends Node

var is_dragging : bool = false
var phase1dict = {3: "red_solution", 5: "green_solution", 7: "blue_solution", 11: "brimstone", 15: "yellow_solution", 21: "magenta_solution", 35: "cyan_solution", 105: "white_solution", 163: "white_solution", 231: "white_solution", 315: "red_perditio", 385: "white_solution", 525: "green_perditio", 735: "blue_perditio", 1155: "white_solution", 1575: "blue_vitae", 2205: "green_vitae", 3465: "red_solution", 3675: "red_vitae", 5755: "green_solution", 8085: "blue_solution", 11025: "brimstone", 17325: "blue_brimstone", 24255: "green_brimstone", 40425: "red_brimstone", 1157625: "aqua_vitae"}
var unrefined_dict = {11: "boom", 1575: "blue_brimstone", 2205: "green_brimstone", 3675: "red_brimstone", 17325: "lead", 24255: "iron", 40425: "potassium", 1157625: "brimstone"}
var unpure_dict = {33: "lead", 55: "potassium", 77: "iron", 121: "lead", 143: "iron", 187: "potassium", 4725: "unrefined_metal", 6615: "unrefined_metal", 7875: "unrefined_metal", 11025: "bismuth", 15435: "unrefined_metal", 17325: "brimstone", 18375: "unrefined_metal", 20475: "boom", 24255: "boom", 25725: "unrefined_metal", 26775: "boom", 28665: "brimstone", 37485: "boom", 40425: "boom", 47775: "boom", 51975: "brimstone", 62475: "brimstone", 72765: "brimstone", 86625: "brimstone", 121275: "boom", 169785: "brimstone", 190575: "purified_bismuth", 202125: "brimstone", 225225: "no effect", 266805: "no effect", 282975: "brimstone", 294525: "no effect", 315315: "purified_quicksilver", 412335: "no effect", 444675: "no effect", 525525: "no effect", 687225: "purified_silver", 3472875: "iron", 5788125: "lead", 8103375: "potassium", 12733875: "iron", 15049125: "potassium", 19679625: "lead"}
var pure_dict = {33: "unrefined_metal", 55: "bismuth", 77: "quicksilver", 3472875: "quicksilver", 5788125: "silver", 8103375: "gold"}
# variables for character starts. If a var is set to "true" the player gets the character modifier.
var char_recipes: bool = false
var char_material: bool = false
var char_patience: bool = false

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

func phase2craft(val1_style: int, val1: int, val2: int) -> String:
	var created: String
	if val1_style == 1: 
		created = unref_metal_craft(val2)
	elif val1_style == 2 or val1_style == 3:
		created = base_metal_craft(val1, val2)
	elif val1_style == 4:
		created = pure_metal_craft(val1, val2)
	else: created = "no effect"
	return created

func unref_metal_craft(val2: int) -> String:
	var created: String
	if unrefined_dict.has(val2): created = unrefined_dict[val2]
	else: created = "no effect"
	return created

func base_metal_craft(val1: int, val2: int) -> String:
	var created: String
	var newval = val1 * val2
	if unpure_dict.has(newval): created = unpure_dict[newval]
	else: created = "no effect"
	return created

func pure_metal_craft(val1: int, val2: int) -> String:
	var created: String
	var newval = val1 * val2
	if pure_dict.has(newval): created = pure_dict[newval]
	else: created = "no effect"
	return created

func character_select_settings():
	pass
