# DomainEventQueue.gd
extends Object
class_name DomainEventQueue

var _queue: Array[DomainEvent] = []

func enqueue(event: DomainEvent) -> void:
	_queue.append(event)

func dequeue() -> DomainEvent:
	if _queue.is_empty():
		return null
	return _queue.pop_front()

func peek() -> DomainEvent:
	return _queue[0] if _queue.size() > 0 else null

func is_empty() -> bool:
	return _queue.is_empty()

func clear() -> void:
	_queue.clear()
