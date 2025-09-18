extends Object
class_name PieceAddedEventHandler
static func handle(event: DomainEvent) -> void:
    var piece : PieceAddedEvent = event.payload.get("piece", null) 
    if piece:
        print("PieceAddedEventHandler: Piece added: ", piece.id, " at position: ", piece.position, " version: ", event.version)
        var x = piece.position.get("x", 0)
        var y = piece.position.get("y", 0)
        DomainBus.evt_piece_added.emit(piece.id, x,y)