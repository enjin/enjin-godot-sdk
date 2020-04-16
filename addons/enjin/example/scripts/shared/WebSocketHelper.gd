class_name WebSocketHelper

enum SendStatus {
    OK, # Indicates that packet sending was successful.
    PEER_NOT_FOUND # Indicates that the peer specified does not exist.
}

# Sends a packet to a connected peer.
# By default the write mode is set to binary.
static func send_packet(client, packet, peer_id = 1, write_mode = WebSocketPeer.WRITE_MODE_BINARY):
    if client is WebSocketServer && !client.has_peer(peer_id):
        return SendStatus.PEER_NOT_FOUND

    var peer = client.get_peer(peer_id)
    peer.set_write_mode(write_mode)

    var encoded_packet = encode(packet, write_mode)
    var error = peer.put_packet(encoded_packet)

    return SendStatus.OK

# Encodes a packet using the specified write mode.
static func encode(packet, write_mode):
    return var2str(packet).to_utf8() if write_mode == WebSocketPeer.WRITE_MODE_TEXT else var2bytes(packet)

# Decodes the packet.
static func decode(packet, is_string: bool):
    return packet.get_string_from_utf8() if is_string else bytes2var(packet)

static func decode_json(packet):
    return parse_json(packet.get_string_from_utf8())

