extends Node

const ROW_REACHED: String = "reached"
const ROW_COMPLETED: String = "completed"
const ROWS: Array[String] = [
	ROW_REACHED,
	ROW_COMPLETED,
]

## Quantum Mirror dot Save
const SAVE_PATH: String = "user://qm.sf"

const START_DATA: Dictionary[String, int] = {
	ROW_REACHED: 0,
	ROW_COMPLETED: 0,
}

var data: Dictionary[String, int] = START_DATA.duplicate(true)


func _init() -> void:
	_load()


## Loads score or set to default
func _load() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		var err: Error = FileAccess.get_open_error()
		if err != ERR_FILE_NOT_FOUND:
			printerr("[Persistence]: loading error:", FileAccess.get_open_error())
		return
	var tmp: Dictionary = JSON.parse_string(file.get_as_text())
	for row: String in ROWS:
		var value: Variant = tmp.get(row)
		if typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT:
			@warning_ignore("unsafe_cast")
			data[row] = roundi(tmp[row] as float)
		else:
			data[row] = START_DATA[row]
	file.close()


## Saves best score from memory to file
func _save() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		push_error("[Persistence]: saving error:", FileAccess.get_open_error())
		return
	if not file.store_string(JSON.stringify(data)):
		push_error("[Persistence]: saving error:", FileAccess.get_open_error())
	file.close()


## Updates a Row in data with new value if it is higher and saves the file
## Can be later extended if needed to act differently according to keys
func submit(row: String, val: int) -> void:
	assert(ROWS.has(row))
	match row:
		_:
			data[row] = maxi(data[row], val)
	_save()


## Resets save data and saves it to save file
func reset() -> void:
	data = START_DATA.duplicate(true)
	_save()
