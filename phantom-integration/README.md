# Phantom Integration on Godot

NOTE: this is a sample code that I've coded up in an hour.

## Some Potential Issues that needs to be considered

1. Injection - users could inject wallet address to make use of assets that are not theirs - need to implement some form of transaction signature verification.

e.g. https://docs.phantom.app/integrating/signing-a-message

2. All interactions are "GET" requests, there's no support for data storage yet. This sample code might be useful for a gallery, but not so much for a full-fledged game.
