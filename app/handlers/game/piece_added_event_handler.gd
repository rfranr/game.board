extends Object
class_name PieceAddedEventHandler
static func handle(event: DomainEvent) -> void:
    var piece : PieceAddedEvent = event.payload.get("piece", null) 
    if piece:
        print("PieceAddedEventHandler: Piece added: ", piece.id, " at position: ", piece.position, " version: ", event.version)
        DomainBus.evt_piece_added.emit(piece.id, piece.position)