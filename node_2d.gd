extends Node2D

# Written by Bradley Turner

# Stores all indexed file paths
var indexed_paths: Array = []
var index_thread := Thread.new()

# Secretary-style "thinking" lines shown while searching
var thinking_lines = [
	"[i]Let me just rummage through the filing cabinet... one moment![/i]",
	"[i]Just a sec, I know I saw that file somewhere...[/i]",
	"[i]Flipping through folders like a pro... hold tight![/i]",
	"[i]One moment. I can't seem to find my glasses...[/i]",
	"[i]Searching the archives... and sipping my tea.[/i]"
]

# Secretary-style "thinking" lines shown when indexing
var indexing_lines = [
	"[i]Server indexing... check. Coffee consumption... increasing by the minute. Bear with me, I'm on it![/i]",
	"[i]NOT ANOTHER SERVER TO INDEX! MY POOR FINGERS ARE TYPING AS FAST AS THEY CAN ALREADY![/i]",
	"[i]I'm experiencing a slight delay due to an unexpected influx of cat videos on the network... Was this you??[/i]",
	"[i]Umm... just a minor technical difficulty... or 12. I'm rebooting my caffeine IV and will be with you shortly. Server indexing: almost there, I swear![/i]",
	"[i]If I don't respond for the next 5 minutes, send help. Or a strongly-worded letter to whoever wrote me. Server indexing: loading...[/i]",
]

# Secretary-style result intros when matches are found
var result_lines = [
	"[b]The server indexing wizard has spoken! {count} files at your fingertips![/b]",
	"[b]After what felt like an eternity, I've managed to scrounge up {count} files. You're welcome, really.[/b]",
	"[b]By the power of indexing, I present to you... {count} files! May they bring you wisdom and knowledge.[/b]",
	"[b]{count} files found! So when is the pay rise?[/b]",
	"[b]Done and dusted! {count} files located.[/b]"
]

# Secretary-style responses when no matches are found
var no_result_lines = [
	"[color=red]Oh dear, I couldn’t find anything matching \"{query}\". Maybe check your spelling, sweetheart?[/color]",
	"[color=red]Nothing turned up for \"{query}\". Want me to try again with a different term?[/color]",
	"[color=red]Hmm... not a single match for \"{query}\". I’m as shocked as you are![/color]",
	"[color=red]Zilch, nada, nothing for \"{query}\". Maybe try running an index?.[/color]"
]

# Node references — make sure these match your scene structure
@onready var index_button = $Button3
@onready var search_button = $Button
@onready var search_input = $LineEdit
@onready var results_display = $RichTextLabel

func _ready():
	# Connect button signals
	index_button.pressed.connect(_on_index_button_pressed)
	search_button.pressed.connect(_on_search_button_pressed)
	results_display.meta_clicked.connect(_on_result_clicked)

	# Load index.txt if it exists
	var index_file_path = "user://index.txt"
	if FileAccess.file_exists(index_file_path):
		var file = FileAccess.open(index_file_path, FileAccess.READ)
		while not file.eof_reached():
			var line = file.get_line()
			if line != "":
				indexed_paths.append(line)
		file.close()
		print("Loaded index from index.txt with ", indexed_paths.size(), " entries.")
		results_display.clear()
		results_display.append_text("Index loaded from file! Feel free to start searching!")
	else:
		results_display.clear()
		results_display.append_text("No index file found, please click index before trying to search. Note, this will take some time.")
		

# Indexing logic — triggered when the Index Button is pressed
func _on_index_button_pressed():
	index_button.disabled = true
	search_button.disabled = true
	
	var indexing = indexing_lines[randi() % indexing_lines.size()]
	results_display.clear()
	results_display.append_text(indexing + "\n\n")
	
	index_thread.start(_threaded_indexing)
	
	await get_tree().create_timer(1.5).timeout
	
# miltithreaded indexing to stop software lag
func _threaded_indexing():
	
	print("New thread opened")
	
	var target_dirs = [
		"C:/", "D:/", "E:/","F:/", "G:/",
		"H:/", "I:/", "J:/","K:/", "L:/",
		"M:/", "N:/", "O:/", "P:/", "Q:/",
		"R:/", "S:/", "T:/","U:/", "V:/",
		"W:/", "X:/", "Y:/", "Z:/"
	]
	
	indexed_paths.clear()
	
	for dir in target_dirs:
		_index_directory(dir, indexed_paths)
		
	# Save to index.txt
	var file = FileAccess.open("user://index.txt", FileAccess.WRITE)
	for path in indexed_paths:
		file.store_line(path)
	file.close()
	print("Index saved to index.txt.")
	
	print("Indexing complete. Total files found: ", indexed_paths.size())
	results_display.append_text("Indexing complete!")
	
	index_button.disabled = false
	search_button.disabled = false
	
	print ("New Tread Closed")

# Search logic — triggered when the Search Button is pressed
func _on_search_button_pressed():
	var query = search_input.text.strip_edges().to_lower()
	results_display.clear()

	if query.is_empty():
		results_display.append_text("[i]Hmm... I'm going to actually need a search term...[/i]")
		return

	# Show a random "thinking" line
	var thinking = thinking_lines[randi() % thinking_lines.size()]
	results_display.append_text(thinking + "\n\n")
	
	# Simulate a short delay for personality
	await get_tree().create_timer(1.5).timeout

	# Filter matching paths
	var matches = indexed_paths.filter(func(path): return path.to_lower().contains(query))

	if matches.is_empty():
		var no_result = no_result_lines[randi() % no_result_lines.size()]
		results_display.append_text(no_result.format({"query": query}))
	else:
		var result_intro = result_lines[randi() % result_lines.size()]
		results_display.append_text(result_intro.format({"count": matches.size()}) + "\n\n")
		for match in matches:
			# Styled clickable link for dark mode
			results_display.append_text("[url=" + match + "][color=#80dfff][u]" + match + "[/u][/color][/url]\n\n")

# Recursively index all files in a directory
func _index_directory(path: String, file_list: Array):
	var dir = DirAccess.open(path)
	if dir == null:
		print("Failed to open directory: ", path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue

		var full_path = path + "/" + file_name
		if dir.current_is_dir():
			_index_directory(full_path, file_list)
		else:
			file_list.append(full_path)

		file_name = dir.get_next()
	dir.list_dir_end()

# Handle clicks on file links
func _on_result_clicked(meta):
	OS.shell_open(meta)  # Opens the file or folder using the default system app
