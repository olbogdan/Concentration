//
//  ViewController.swift
//  Concentration
//
//  Created by bogdanov on 18.03.21.
//

import UIKit

class ViewController: UIViewController {
    lazy var game = Concentration(numberOfPairOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }

    private var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips \(flipCount)"
        }
    }
    
    @IBOutlet var flipCountLabel: UITextField!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    // MARK: Handle Card Touch Behaviour

    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
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
    
    var emojiChoises = ["🤡", "❤️", "✏️", "🌲", "🏡", "👩‍🎓", "🧑‍💻", "🏋️"]
    
    var emoji = [Int: String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoises.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoises.count)))
            emoji[card.identifier] = emojiChoises.remove(at: randomIndex)
        }
        
        return emoji[card.identifier] ?? "?"
    }
}
