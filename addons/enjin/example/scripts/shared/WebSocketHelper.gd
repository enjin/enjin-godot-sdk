class_name WebSocketHelper

enum SendStatus {
    OK
    PEER_NOT_FOUND
}

static func send_packet(client, packet, peer_id = 1, write_mode = WebSocketPeer.WRITE_MODE_BINARY):
    if client is WebSocketServer && !client.has_peer(peer_id):
        return SendStatus.PEER_NOT_FOUND

    var peer = client.get_peer(peer_id)
    peer.set_write_mode(write_mode)

    var encoded_packet = encode(packet, write_mode)
    var error = peer.put_packet(encoded_packet)

    return SendStatus.OK

static func encode(packet, write_mode):
    return packet.to_utf8() if write_mode == WebSocketPeer.WRITE_MODE_TEXT else var2bytes(packet)

static func decode(packet, is_string: bool):
    return packet.get_string_from_utf8() if is_string else bytes2var(packet)
