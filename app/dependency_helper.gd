extends Object
class_name DependencyHelper

static var _instances = {}

static func get_instance(name: String) -> Object:
    if _instances.has(name):
        return _instances[name]
    assert(false, "No instance found for name: %s" % name)    
    return null
    
static func set_instance(name: String, instance: Object) -> void:
    _instances[name] = instance
    return