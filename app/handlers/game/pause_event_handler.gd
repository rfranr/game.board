extends Object
class_name PauseEventHandler
static func handle(event: DomainEvent) -> void:
    var state : PauseToggledEvent = event.payload.get("state", null) 
    if state:
        print("PauseEventHandler: Game paused state is now: ", state.paused, " version: ", event.version)
        DomainBus.cmd_toggle_pause.emit(state.paused)