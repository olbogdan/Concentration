//
//  Concentration.swift
//  Concentration
//
//  Created by bogdanov on 20.03.21.
//

import Foundation

struct Concentration {
    private(set) var cards = [Card]()

    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            let faceUpCardsIndices = cards.indices.filter { cards[$0].isFaceUp }
            return faceUpCardsIndices.count == 1 ? faceUpCardsIndices.first : nil
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }

    init(numberOfPairOfCards: Int) {
        assert(numberOfPairOfCards > 0, "Concentration.init(\(numberOfPairOfCards)) you mast have at least one pair of cards")
        resetCards(numberOfPairOfCards)
    }

    mutating func resetCards(_ numberOfPairOfCards: Int) {
        indexOfOneAndOnlyFaceUpCard = nil
        cards.removeAll()
        for _ in 1 ... numberOfPairOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }

    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "chosen index \(index) is not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
}
