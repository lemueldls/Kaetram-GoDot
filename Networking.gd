extends Node2D

const GAME_URL = "ws://127.0.0.1:9003";

var _client = WebSocketClient.new()

func _ready():
	create_websocket_connection()

func create_websocket_connection():
	_client.connect("connection_closed", self, "_on_closed")
	_client.connect("connection_error", self, "_on_error")
	_client.connect("connection_established", self, "_on_connected")
	_client.connect("data_received", self, "_on_data")

	var status = _client.connect_to_url(GAME_URL)

	if status != OK:
		set_process(false)
		push_error('Unable to connect.')

func _on_closed(was_clean = false):
	set_process(false)
	push_error('Connection closed, clean: ' + str(was_clean))

func _on_error():
	set_process(false)
	push_error('An error has occurred while trying to connect.')

func _on_connected(protocol = ""):
	print('Successfully connected with protocol: ' + protocol)

func _on_data():
	print('Received data.')
	print(_client.get_peer(1).get_packet().get_string_from_utf8())
	
	#    print("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8())

func _process(_delta):
	_client.poll()
