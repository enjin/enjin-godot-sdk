extends Node

var TrustedPlatformClient = preload("res://addons/enjin/sdk/TrustedPlatformClient.gd")
var client: TrustedPlatformClient

func _init():
    client = TrustedPlatformClient.new()