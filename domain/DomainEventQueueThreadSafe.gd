extends RefCounted
class_name DomainEventQueueThreadSafe
# Simple thread-safe queue for domain events
# Note: This is a basic toy implementation. Do not use for web export.

var _q: Array = []
var _mutex := Mutex.new()

func enqueue(ev) -> void:
    _mutex.lock()
    _q.push_back(ev)     # ev should be pure data (Dictionary or simple RefCounted), no Nodes
    _mutex.unlock()

func try_dequeue():
    _mutex.lock()
    var ev = _q.pop_front() if _q.size() > 0 else null
    _mutex.unlock()
    return ev

# Optional: drain all at once (fewer locks)
func drain_all() -> Array:
    _mutex.lock()
    var out := _q
    _q = []
    _mutex.unlock()
    return out

func size() -> int:
    _mutex.lock()
    var s = _q.size()
    _mutex.unlock()
    return s    

func is_empty() -> bool:
    _mutex.lock()
    var empty = _q.size() == 0
    _mutex.unlock()
    return empty