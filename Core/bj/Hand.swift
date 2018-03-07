import Foundation

class Hand: BJHand, Hashable {
    
    var cards: [Card] = []
    private(set) var hashValue: Int = 0
    private(set) var id: String
    
    init(_ id: String) {
        self.id = id
        self.hashValue = id.hashValue
    }
    convenience init() {
        self.init("0")
    }
    func getFinalScore() -> Int {
        let score = self.getScore()

        guard let softScore = score.soft else {
            return score.hard
        }
        guard score.hard < BlackJackConstants.MAX_SCORE else {
            return softScore
        }

        return score.hard
    }


    func getScore() -> (hard: Int, soft: Int?) {
        var score = 0
        var aces = 0

        for card in self.cards {
            if card.rank == Rank.Ace {
                aces += 1
            } else {
                score += card.score.hard
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

    func clear() {
        self.cards = []
    }

    static func ==(lhs: Hand, rhs: Hand) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
