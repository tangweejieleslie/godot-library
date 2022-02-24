extends Node2D

# Docs
# public solscan https://public-api.solscan.io/account/tokens?account=WALLET_ADDRESS
var WALLET_ADDRESS
var NFT_ADDRESS = []
var IMAGE_URI = "https://arweave.net/S-fRo6zoCOKYWlUMo6SEj2uvpwPDfPOZnfLzIEUYGnA"
var isWalletConnected = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Could be optimized in the future
func _process(delta):
	if isWalletConnected:
		$HBoxContainer/Actions/GetNFTAddress.disabled = false
	if NFT_ADDRESS.size() != 0:
		$HBoxContainer/Actions/GetNFTDetails.disabled = false

#
#	PHANTOM WALLET FUNCTIONS
#

var PhantomRequestCallback = JavaScript.create_callback(self, "phantom_request_callback")
# returns wallet address
func phantom_request_callback(args):
	print("Phantom Request Callback initiated.")
	$HBoxContainer/BasicData/Wallet/WalletAddress.text = String(args[0].publicKey.toString())
	WALLET_ADDRESS = String(args[0].publicKey.toString())
	print("Wallet Address: ",WALLET_ADDRESS)
	if WALLET_ADDRESS != null:
		isWalletConnected = true

func _on_ConnectPhantom_pressed():
	var window = JavaScript.get_interface("window")
	window.solana.connect().then(PhantomRequestCallback)
	
func _on_Web_phantom_completed(args):
	print("callback: ", args)
	pass # Replace with function body.
	
#
#	HTTP GET IMAGE FUNCTION, HARDCODED TO JPG FOR NOW
#

# How to load image from web into godot
# https://docs.godotengine.org/en/3.2/classes/class_httprequest.html#class-httprequest
# Not connected to signal for now
func _on_GetImage_pressed():
	GetImage(IMAGE_URI)
	pass # Replace with function body.

func GetImage(url):
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_get_jpg_http_request_completed")

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request(url)
	print(error)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _get_jpg_http_request_completed(result, response_code, headers, body):
	var image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	# Hard coded sample
	$HBoxContainer/NFTMeta/TextureRect.texture = texture
	


#
#	SOLSCAN FUNCTION - GET TOKENS FROM WALLET
#

func _on_GetNFTAddress_pressed():
	# API End point
	var url = "https://public-api.solscan.io/account/tokens?account=%s" % WALLET_ADDRESS
	GetTokensFromWalletAddress(url)

func GetTokensFromWalletAddress(url):
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_get_token_http_request_completed")

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _get_token_http_request_completed(result, response_code, headers, body):
	var response_array = parse_json(body.get_string_from_utf8())
	print(response_array)
	for token in response_array:
		var label = Label.new()
		if token.has("tokenAddress"):
			label.text = token.tokenAddress
		# $TokensList/TokenContainter.add_child(label)
		$HBoxContainer/BasicData/ListOfNFT.add_child(label)
		NFT_ADDRESS.append(token.tokenAddress)
	# $TokensList.text = response


#
#	SOLSCAN FUNCTION - GET NFT DATA FROM NFT ADDRESS
#

export var NFT_INDEX = 0

# TODO - defensive coding for when NFT_ADDRESS is empty
func _on_GetNFTDetails_pressed():
	var NFT_Data = "https://public-api.solscan.io/account/%s" % NFT_ADDRESS[NFT_INDEX]
	GetNFTfromWallet(NFT_Data)

func GetNFTfromWallet(url):
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_get_nft_http_request_completed")

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
# Differs across NFT
func _get_nft_http_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
	print("NFT: ", response)
	var metadata = response.metadata.data
	print(metadata)
	var tokenName = response.tokenInfo.name
	print(tokenName)
	var properties = metadata.properties
	print(properties)
	var image_url = metadata.image
	GetImage(image_url)
	
	$HBoxContainer/NFTMeta/NFTName.text=tokenName
	$HBoxContainer/NFTMeta/NFTAddress.text=NFT_ADDRESS[NFT_INDEX]








