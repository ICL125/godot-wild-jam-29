extends class_menu_tab

onready var _play_button := $VBoxContainer/VBoxContainer/PlayButton
onready var _settings_button := $VBoxContainer/VBoxContainer/SettingsButton
onready var _quit_button := $VBoxContainer/VBoxContainer/QuitButton

onready var _status_label := $VBoxContainer/StatusLabel

onready var _new_button := $VBoxContainer/StateHBox/NewButton
onready var _save_button := $VBoxContainer/StateHBox/SaveButton
onready var _load_button := $VBoxContainer/StateHBox/LoadButton

const NEW_TEXT := "NEW_NOTIFICATION"
const SAVE_TEXT := "SAVE_NOTIFICATION"
const LOAD_TEXT := "LOAD_NOTIFICATION"

func _ready():
	var _error : int = _play_button.connect("pressed", self, "_on_play_button_pressed")
	_error = _settings_button.connect("pressed", self, "_on_settings_button_pressed")

	if OS.get_name() == "HTML5":
		_quit_button.visible = false
	else:
		_quit_button.visible = true
		_error = _quit_button.connect("pressed", self, "_on_quit_button_pressed")

	_error =_new_button.connect("pressed", self, "_on_new_button_pressed")
	_error =_save_button.connect("pressed", self, "_on_save_button_pressed")
	_error =_load_button.connect("pressed", self, "_on_load_button_pressed")

func update_tab():
	_status_label.text = ""

func _on_play_button_pressed():
	Flow.go_to_game()
		
func _on_settings_button_pressed():
	emit_signal("button_pressed", TABS.SETTINGS)

func _on_new_button_pressed():
	_status_label.text = NEW_TEXT
	Flow.new_game()

func _on_save_button_pressed():
	_status_label.text = SAVE_TEXT
	Flow.save_game()

func _on_load_button_pressed():
	_status_label.text = LOAD_TEXT
	Flow.load_game()

func _on_button_mouse_entered():
	pass
