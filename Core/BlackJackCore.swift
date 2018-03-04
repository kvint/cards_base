import Foundation
enum GameError: Error {
    case deckEmpty
}
extension Card {
    var score: (hard: Int, soft: Int?) {
        var h: Int = 0
        var s: Int? = nil

        switch (self.rank) {
        case .c2: h = 2; break;
        case .c3: h = 3; break;
        case .c4: h = 4; break;
        case .c5: h = 5; break;
        case .c6: h = 6; break;
        case .c7: h = 7; break;
        case .c8: h = 8; break;
        case .c9: h = 9; break;
        case .c10, .Jack, .Queen, .King:
            h = 10;
            break;
        case .Ace:
            h = 11;
            s = 1;
            break;
        }
        return (hard: h, soft: s);
    }
}