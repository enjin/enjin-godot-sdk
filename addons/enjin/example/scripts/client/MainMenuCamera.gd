extends Camera2D
export(int) var time
export(Array, NodePath) var points: Array

var _current_idx: int
var _tween: Tween

func _ready():
    _tween = $Tween
    
    if points.size() == 0:
        return
    
    self.position = _get_point(0).position
    
    if points.size() < 2:
        return
    
    _tween.start()
    _move_to_next_point()

func _move_to_next_point():
    if _current_idx == points.size() - 1:
        _current_idx = 0
        self.position = _get_point(0).position
    
    _tween.interpolate_property(self, "position", _get_point(_current_idx).position, _get_point(_current_idx + 1).position, _get_time())

func _get_point(idx) -> Node:
    return get_node(points[idx])

func _get_time() -> float:
    if points.size() < 2:
        return time
    
    var start: Position2D = _get_point(0)
    var end: Position2D = _get_point(points.size() - 1)
    var total_distance: float = abs(end.position.x - start.position.x)
    
    var current: Position2D = _get_point(_current_idx)
    var next: Position2D = _get_point(_current_idx + 1)
    var local_distance: float = abs(next.position.x - current.position.x)
    
    return (local_distance / total_distance) * time

func _on_tween_complete(object, key):
    _current_idx += 1
    _move_to_next_point()
