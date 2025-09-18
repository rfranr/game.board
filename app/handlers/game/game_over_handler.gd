extends Object
class_name GameOverEventHandler
static func handle(event: DomainEvent) -> void:
    var state : GameOverEvent = event.payload.get("result", null) 
    if state:
        print("GameOverEventHandler: Game over! Winner is: ", state.winner, " version: ", event.version)
        DomainBus.cmd_game_over.emit(state.winner)