//
//  Card.swift
//  Concentration
//
//  Created by bogdanov on 20.03.21.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int

    private static var identifierfactorry = 0

    private static func getUniqueIdentifier() -> Int {
        identifierfactorry += 1
        return identifierfactorry
    }

    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
