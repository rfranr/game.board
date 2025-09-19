extends Object
class_name PiecesAddedEventHandler
static func handle(event: DomainEvent) -> void:
    var pieces : PiecesAddedEvent = event.payload.get("pieces", null) 
    if pieces:
        var positions: Array[Dictionary] = pieces.positions
        DomainBus.evt_pieces_added.emit(positions)

        
