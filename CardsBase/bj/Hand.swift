import Foundation

class Hand: BJHand, Hashable {
    
    var isDone: Bool = false
    var payedOut: Bool = false
    
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
        return Card.getFinalScore(cards: self.cards)
    }

    func gotBusted() -> Bool {
        return self.getScore().hard > BlackJackConstants.MAX_SCORE
    }
    func gotBlackjack() -> Bool {
        return self.cards.count == 2 && self.getScore().hard == BlackJackConstants.MAX_SCORE
    }
    func gotCharlie() -> Bool {
        return false
    }
    func getScore() -> (hard: Int, soft: Int?) {
        return Card.getScore(cards: self.cards)
    }

    func clear() {
        self.cards = []
        self.payedOut = false
    }

    static func ==(lhs: Hand, rhs: Hand) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
