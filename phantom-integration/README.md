# Phantom Integration on Godot

NOTE: this is a sample code that I've coded up in an hour.

Pre-conditions: 
- user have Phantom Wallet extension installed
- user already have a wallet
- user have at least 1 NFT in their wallet
- user is using Chrome Browser

## Some Potential Issues that needs to be considered

1. Injection - users could inject wallet address to make use of assets that are not theirs - need to implement some form of transaction signature verification.

e.g. https://docs.phantom.app/integrating/signing-a-message

2. All interactions are "GET" requests, there's no support for data storage yet. This sample code might be useful for a gallery, but not so much for a full-fledged game.

## Future Extension
- display all NFT (currently only displaying the first NFT in their wallet)
- support for other image type, e.g. png, gif
- support for other media type, e.g. videos, audio
- support for other wallets, e.g. Metamask


## Slides on High Level Flow
https://docs.google.com/presentation/d/1NORBqLScNMOkygLjyTyUw52PXO7i-svpn6OIQJykBas/edit#slide=id.p 


## References

### Phantom Docs
https://docs.phantom.app/integrating/establishing-a-connection

### Godot Docs
https://docs.godotengine.org/en/stable/classes/class_javascript.html#class-javascript-method-create-callback  
https://docs.godotengine.org/en/stable/tutorials/networking/http_request_class.html 

### Solscan Docs
https://public-api.solscan.io/docs/#/Account/get_account_tokens 
https://public-api.solscan.io/docs/#/Account/get_account__account_

