import Foundation

enum Suit: Int, CustomStringConvertible {

    case Spades, Hearts, Diamonds, Clubs

    static func random() -> Suit {
        let max = Clubs.rawValue
        let rand = arc4random_uniform(UInt32(max))
        return Suit(rawValue: Int(rand))!
    }

    var description: String {
        switch (self) {
        case Suit.Spades: return "♠️"
        case Suit.Hearts: return "♥️"
        case Suit.Clubs: return "♣️"
        case Suit.Diamonds: return "♦️"
        }
    }
}

enum Rank: Int, CustomStringConvertible {

    case c2, c3, c4, c5, c6, c7, c8, c9
    case c10, Jack, Queen, King
    case Ace

    static func random() -> Rank {
        let max = Ace.rawValue
        let rand = arc4random_uniform(UInt32(max))
        return Rank(rawValue: Int(rand))!
    }

    var description: String {
        switch (self) {
        case .Ace: return "A"
        case .King: return "K"
        case .Queen: return "Q"
        case .Jack: return "J"
        case .c10: return "10"
        case .c9: return "9"
        case .c8: return "8"
        case .c7: return "7"
        case .c6: return "6"
        case .c5: return "5"
        case .c4: return "4"
        case .c3: return "3"
        case .c2: return "2"
        }
    }
}

struct Card: CustomStringConvertible, Hashable {
    var suit: Suit
    var rank: Rank

    private(set) var hashValue: Int = 0

    init(_ rank: Rank, _ suit: Suit = Suit.Clubs) {
        self.rank = rank;
        self.suit = suit;
        self.hashValue = suit.hashValue | (rank.hashValue << 16)
    }

    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    var description: String {
        return "\(suit)\(rank)";
    }
}

func Deck() -> Set<Card> {
    var cards: Set<Card> = []
    for rank in [
        Rank.c2, Rank.c3, Rank.c4, Rank.c5, Rank.c6, Rank.c7, Rank.c8, Rank.c9,
        Rank.c10, Rank.Jack, Rank.Queen, Rank.King,
        Rank.Ace
    ] {
        for suit in [Suit.Spades, Suit.Hearts, Suit.Diamonds, Suit.Clubs] {
            cards.insert(Card(rank, suit))
        }
    }
    return cards;
}