import Foundation
enum GameError: Error {
    case deckEmpty
}
public typealias BJScore = (hard: Int, soft: Int?)

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
    
    public static func getScore(cards: [Card]) -> BJScore {
        var score = 0
        var aces = 0
        
        cards.forEach { (card) in
            if !card.hidden {
                if card.rank == Rank.Ace {
                    aces += 1
                } else {
                    score += card.score.hard
                }
            }
        }
        
        if aces > 0 {
            let soft = score + aces
            if score > 11 {
                return (hard: soft, soft: nil)
            } else {
                return (hard: score + 10 + aces, soft: soft)
            }
        }
        return (hard: score, soft: nil)
    }
    
    public static func getFinalScore(cards: [Card]) -> Int {
        let score = Card.getScore(cards: cards)
        
        guard let softScore = score.soft else {
            return score.hard
        }
        guard score.hard <= BlackJackConstants.MAX_SCORE else {
            return softScore
        }
        
        return score.hard
    }

}
