//
//  ViewController.swift
//  Concentration
//
//  Created by bogdanov on 18.03.21.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game = Concentration(numberOfPairOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }

    private private(set) var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips \(flipCount)"
        }
    }
    
    @IBOutlet private var flipCountLabel: UITextField!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    // MARK: Handle Card Touch Behaviour

    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction private func restartGame(_ sender: UIButton) {
        flipCount = 0
        emojiChoises = ["🤡", "❤️", "✏️", "🌲", "🏡", "👩‍🎓", "🧑‍💻", "🏋️"]
        game.resetCards(numberOfPairsOfCards)
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = UIColor.white
            } else {
                button.setTitle(nil, for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? nil : UIColor.orange
            }
        }
    }
    
    private var emojiChoises = ["🤡", "❤️", "✏️", "🌲", "🏡", "👩‍🎓", "🧑‍💻", "🏋️"]
    
    private var emoji = [Card: String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoises.count > 0 {
            emoji[card] = emojiChoises.remove(at: emojiChoises.count.arc4random)
        }
        
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
