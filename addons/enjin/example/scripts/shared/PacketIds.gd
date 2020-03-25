class_name PacketIds

enum {
    HANDSHAKE, # Client sends HANDSHAKE packet to initiate authentication process.
    PLAYER_AUTH, # Server sends PLAYER_AUTH packet to forward auth token to the client.
    SEND_TOKEN # Player sends SEND_TOKEN packet to inform the server to send a token to the clients wallet.
}
